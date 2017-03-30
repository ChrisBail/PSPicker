function S=refine_PICKS(EVENT,mainfile,flag_plot_level)

% Refine picks
% The program takes an EVENT input (structure), reads the origin and the picks
% extract the mseed, pick with the kurtosis and relocate the event
% 
%  Input: EVENT > EVENT structure (type: struct)
%         mainfile > main configuration filename (type: str)
%         flag_plot > flag used in debug mode to plot grap (type: boolean)
%         
%  Output:    S > Output EVENT containing new refined picks and new location (type: struct)
%  
%  Example:   NEW_EVENT=refine_PICKS(OLD_EVENT,'mainfile.txt',0)
%  

clearvars -except EVENT mainfile flag_plot_level

%%% Define flag_plot level

flag_plot=level2flagplot(3,flag_plot_level);

%%% Read main file

PickerParam=readmain(mainfile);  

%%% Create junk repos for temporary files

if ~exist('tmp','dir')
    mkdir('tmp')
end

if ~exist('hyp','dir')
    mkdir('hyp')
end

%%% Copy STATION0.HYP file to hyp directory

copyfile(PickerParam.station_file,'./hyp/')

%%% Parameters that shouldn't be changed

output_mseed='./tmp/cat.mseed';
snr_P_thres=90; % snr limit to consider trace
snr_S_thres=90; % snr limit to consider trace
grad_thres=70; % max gradient threshold of trace distribution 
kurtoratio_thres=20;
hyp=PickerParam.hyp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get parameters from PickerParam

delay_before=PickerParam.extract_time(1);
delay_after=PickerParam.extract_time(2);
window_P=PickerParam.window_P;
window_S=PickerParam.window_S;
channels=chanlist_PARAM(PickerParam);
channels_str=strjoin(channels);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get List of stations to be processed from mainfile

stations=fieldnames(PickerParam.Station_param);
stations_str=strjoin(stations);

%%% Compute theoretical arrival times

EVENT=comp_THEO(hyp,EVENT);

%%% Only get stations referenced in Parameter file

EVENT.PHASES=get_PHASE(EVENT.PHASES,'station',stations);

%%%%%%%%%%%%%%%%%%%%%
%%% Extract mseed %%%
%%%%%%%%%%%%%%%%%%%%%

start_time=min([EVENT.PHASES.THEO])-delay_before/86400;
end_time=max([EVENT.PHASES.THEO])+delay_after/86400;

start_time_str=datestr(start_time,...
        'yyyy-mm-dd HH:MM:SS');
end_time_str=datestr(end_time,...
        'yyyy-mm-dd HH:MM:SS');    

cmd=sprintf('-start "%s" -end "%s" -sta "%s" -comp "%s" -sds "%s" -o "%s"',...
   start_time_str,end_time_str,stations_str,channels_str,PickerParam.sds_path,output_mseed);

call_sds2mseed(cmd);

%[~,~]=system([sds2mseed,' ',cmd]);

%%%%%%%%%%%%%%%%%%
%%% Read file %%%%
%%%%%%%%%%%%%%%%%%

X=rdmseed(output_mseed);
S=get_DATA(X);
clear X

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Start picking process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EVENT.COLOR=[1 0 0];

%%% Initialize Event structure to store picks

DATA=S.DATA;
PHASES=EVENT.PHASES;

%%% Compute SNR for all traces present in DATA

DATA=get_SNR(DATA,...
    PickerParam.SNR_wind(1),...
    PickerParam.SNR_wind(2),...
    PickerParam.SNR_freq);

%%% Start loop

for iter=1:length(DATA) % iter goes trough all the stations (for one iter we can analyse all the 4 components)
    
    close all
    
    %%% Initialize all thresholds
    
    max_value=[];
    weight_Pn=[];
    ind_Pn=[];
    ind_S=[];
    ind_P=[];
    pick_flag_S=1;
    station=DATA(iter).STAT;
    rsample=DATA(iter).RSAMPLE;
    boolean_presnr=[];
    boolean_gaussian=[];
    boolean_kurto=[];
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Reject stations not listed for picking in mainfile.txt %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~any(strcmp(strtrim(station),fieldnames(PickerParam.Station_param))) ...
            || isempty(PickerParam.Station_param.(station).pick)
        continue
    end

    %% Check if station contains data
    
    if isempty({DATA(iter).RAW(:).TRACE})
        continue
    end
    
    %% Read theoretical pick for P and S from event structure to fill window
    
    [PHASE_P,ind_Pphase]=get_PHASE(PHASES,'station',station,'type','P');
    time_P=PHASE_P.THEO;
    
    PHASES(ind_Pphase).WINDOW(1)=time_P-window_P(1)/(86400);
    PHASES(ind_Pphase).WINDOW(2)=time_P+window_P(2)/(86400);
    
    [PHASE_S,ind_Sphase]=get_PHASE(PHASES,'station',station,'type','S');
    time_S=PHASE_S.THEO;
    
    PHASES(ind_Sphase).WINDOW(1)=time_S-window_S(1)/(86400);
    PHASES(ind_Sphase).WINDOW(2)=time_S+window_S(2)/(86400);
    
    %%% if beginning of window time S 1 lower than time P, then redefine
    %%% time S window 1 based on delay
    
    delay=(time_S-time_P)*86400; % delay in seconds
    
    if PHASES(ind_Sphase).WINDOW(1)<=time_P
        PHASES(ind_Sphase).WINDOW(1)=time_S-0.5*delay/(86400);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%  Compute P  %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%% PRE-PROCESSING
    %%% Select channel that has to be processed depending on noise level

    P_channelID=PickerParam.Station_param.(station).pick.P.channelID;
    DATA_P=select_DATA(DATA,station,'channelID',P_channelID);
    levels_P=[];
    window=PHASES(ind_Pphase).WINDOW;
    
    %%%%%%%%%%%%%%%%%%%
    %%% Check Filters
    
    boolean_presnr=ones(numel(DATA_P.RAW),1);
    boolean_gaussian=ones(numel(DATA_P.RAW),1);
    boolean_kurto=ones(numel(DATA_P.RAW),1);
    
    for j=1:length(DATA_P.RAW)
        smooth_snr=100;
        filter_value=PickerParam.SNR_freq;
        percent_thres=0.4;
        snr=DATA_P.RAW(j).SNR;
        trace=DATA_P.RAW(j).TRACE;
        t_begin=DATA_P.RAW(j).TIMESTART;
        first_sample=abs2rela(window(1)-20/86400,t_begin,rsample);
        last_sample=abs2rela(window(2)+10/86400,t_begin,rsample);
        
        %%% Apply filter to trace
        
        trace=filterbutter(3,filter_value(1),filter_value(2),rsample,trace);
        
        %%% Check SNR
        
        [level,scr]=noise_level(snr,first_sample,last_sample,smooth_snr,percent_thres,flag_plot(3));      
        if level>=snr_P_thres
           boolean_presnr(j)=0;
        end
        
        %%% Check Gaussianity
        
        max_gradient=maxgrad_histo(trace,first_sample,last_sample,flag_plot(3));
        if max_gradient>=grad_thres
           boolean_gaussian(j)=0;
        end
        
        %%% Check kurto _distrib
        
        [ratio_low,std_value]=histo_kurto(trace,first_sample,last_sample,100,1.5,flag_plot(3));

        if ratio_low>=kurtoratio_thres
           boolean_kurto(j)=0;
        end
    end
    
    %%% Select traces
    
    flag_levels = boolean_presnr & boolean_gaussian & boolean_kurto;
    
    if ~any(flag_levels) % if all are 0
        continue
    else
        DATA_P.RAW=DATA_P.RAW(flag_levels==1);
    end
    
    %%%%%%% Start picking P on all selected channels
    
    %%%% Initialize

    max_snr_n=zeros(numel(DATA_P.RAW),1);
    max_kurto_n=zeros(numel(DATA_P.RAW),1);
    ind_P_n=nan(numel(DATA_P.RAW),1);
    trace_Pn={};
    trace_S=[];
    %%% Pick on each channels
    
    for j=1:numel(DATA_P.RAW)
        
        trace_Pn(j)={DATA_P.RAW(j).TRACE};
        trace_P=trace_Pn{j};
        
        %%% Compute Kurtosis for P

        t_begin=DATA_P.RAW.TIMESTART;
        first_sample=round((window(1)-t_begin)*86400*rsample);
        last_sample=round((window(2)-t_begin)*86400*rsample);

        [all_mean_M,M,CF_time]=trace2FWkurto(trace_P,rsample,...
                PickerParam.Station_param.(station).pick.P.Kurto_F,...
                PickerParam.Station_param.(station).pick.P.Kurto_W,...
                1,first_sample,last_sample);

    	%%% Pick the onset on CF 

        [ind_pick,vals_kurto]=follow_extrem2(CF_time,...
             PickerParam.max_drift*rsample,flag_plot);

        if isempty(ind_pick)
            fprintf(1,'WARNING: not P phase found for station %s\n',station);
            continue
        end
        
        %%% Feed pick array
        
        ind_P_n(j)=ind_pick;

        %%% Compute max SNR

        window_snr=[2 2];
        LTA_snr=PickerParam.SNR_wind(1);
        STA_snr=PickerParam.SNR_wind(2);
        smooth_snr=5;

        fil_trace_P=filterbutter(3,PickerParam.SNR_freq(1),PickerParam.SNR_freq(2),rsample,trace_P);
        [snr,max_ind,max_snr]=snr_function(abs(fil_trace_P),...
            rsample,LTA_snr,STA_snr,smooth_snr,...
            ind_P_n(j)-window_snr(1)*rsample,ind_P_n(j)+window_snr(2)*rsample,flag_plot);
        
        max_snr_n(j)=max_snr;
        
        %%% Compute max Kurto
        
        scr=quantile(vals_kurto,4);
        max_kurto_n(j)=scr(end);

    end
    
    %%% Select best pick based on SNR or KURTO
    
    boolean_snr_P=zeros(numel(DATA_P.RAW),1);
    boolean_kurto_P=zeros(numel(DATA_P.RAW),1);
    
    if strcmp(PickerParam.weight_switch,'SNR')
       
        boolean_snr_P=(max_snr_n>=PickerParam.SNR2W_P(1) &...
            max_snr_n==max(max_snr_n));
        if ~any(boolean_snr_P)
            weight_P=4;
            ind_P=[];
            trace_P=trace_Pn{1};
        else
            weight_P=get_weight(max(max_snr_n),PickerParam.SNR2W_P);
            ind_P=ind_P_n(boolean_snr_P);
            trace_P=trace_Pn{boolean_snr_P};
        end
        
    else
        
        boolean_kurto_P=(max_kurto_n>=PickerParam.KURTO2W_P(1) &...
            max_kurto_n==max(max_kurto_n));
        if ~any(boolean_kurto_P)
            weight_P=4;
            ind_P=[];
            trace_P=trace_Pn{1};
        else
            weight_P=get_weight(max(max_kurto_n),PickerParam.KURTO2W_P);
            ind_P=ind_P_n(boolean_kurto_P);
            trace_P=trace_Pn{boolean_kurto_P};
        end
        
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%  Compute S  %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    ind_S=[];
    first_sample_S=[];
    last_sample_S=[];
    window=PHASES(ind_Sphase).WINDOW;
    
    %%% Check if parameters for picking S are given in the mainfile
    
    if ~ismember('S',fieldnames(PickerParam.Station_param.(station).pick))
        pick_flag_S=0;
    else
        S_channelID=PickerParam.Station_param.(station).pick.S.channelID;
        DATA_S=select_DATA(DATA,station,'channelID',S_channelID);
        if isempty(DATA_S.RAW)  % Don't try to pick a S if noise is too big on P
            pick_flag_S=0;
        end
    end
    
    %% Start picking on energy
    
    if pick_flag_S==1;
        
        max_value=[];
        clear boolean_snr boolean_gap 
        
        %%%%%%%%%%%%%%%%
        %%% SNR TEST %%%
        %%%%%%%%%%%%%%%%
        
        SNR_PARAM=init_SNRTEST();
        SNR_PARAM.time_phase=time_S;
        SNR_PARAM.window=[time_S-window(1) window(2)-time_S].*86400;
        SNR_PARAM.threshold=1.5;
        SNR_PARAM.LTA=1;
        SNR_PARAM.STA=1;
        SNR_PARAM.filter_band=[1 10];
      
        [boolean_snr,max_snr,SNR]=pass_SNRTEST(DATA_S,SNR_PARAM,flag_plot(3));
      
        %%%%%%%%%%%%%%%%
        %%% GAP TEST %%%
        %%%%%%%%%%%%%%%%
        
        GAP_PARAM.limit=3;
        GAP_PARAM.gap_value=0;
        GAP_PARAM.time_phase=time_S;
        GAP_PARAM.window=[time_S-window(1) window(2)-time_S].*86400;
        
        boolean_gap=pass_GAPTEST(DATA_S,GAP_PARAM,flag_plot(3));
        
        %%%%%%%%%%%%%%%%%%%%%
        %%% GAUSSIAN test %%%
        %%%%%%%%%%%%%%%%%%%%%
        
        GAUSSIAN_PARAM.grad_threshold=10;
        GAUSSIAN_PARAM.time_phase=time_S;
        GAUSSIAN_PARAM.window=[10 10];
        
        boolean_gaussian=[];
        [boolean_gaussian,max_gradient]=pass_GAUSSIANTEST(DATA_S,GAUSSIAN_PARAM,flag_plot(3));

        %%%%%%%%%%%%%%%%%%%%%%%%
        %%% Multiply booleans %%
        %%%%%%%%%%%%%%%%%%%%%%%%
        
        boolean_select=boolean_snr & boolean_gap & boolean_gaussian;
        
        if ~any(boolean_select)
            pick_flag_S=0;
            continue
        else
            DATA_S.RAW=DATA_S.RAW(boolean_select);
        end
        
        trace_S=DATA_S.RAW.TRACE;
        
        %%% Define characteristic function (if more than 1 then we pick on
        %%% energy)
        
        filt_S=filterbutter(3,1,10,rsample,trace_S);
        
        if size(filt_S,2)>1
            cf_S=sum(filt_S.^2,2);
            env_S=envelope(cf_S,50,'maxi');
        else
            cf_S=filt_S;
            env_S=envelope(cf_S.^2,50,'maxi');
        end

        %%% Defines windows for S
        
        delay_sample=delay*rsample;
        window=PHASES(ind_Sphase).WINDOW;
        
        first_sample_S=abs2rela(window(1),t_begin,rsample);
        last_sample_S=abs2rela(window(2),t_begin,rsample);
        
        if first_sample_S<ind_P+0.5*delay_sample; % To be changed !!!
            first_sample_S=round(ind_P+0.5*delay_sample);
        end
        
        %%%% If asked look for max around S
        
        if PickerParam.window_max_S
            [~,ind_Max]=max(same_inc(env_S,first_sample_S,last_sample_S));

            %%% Redefine last sample to max Energy
             last_sample_S=ind_Max;
       
        end
        
       %%%% Compute Kurtosis 
       
       [all_mean_M,M,CF_time]=trace2FWkurto(cf_S,rsample,...
            PickerParam.Station_param.(station).pick.S.Kurto_F,...
            PickerParam.Station_param.(station).pick.S.Kurto_W,...
            1,first_sample_S,last_sample_S);
        
        kurto_S=all_mean_M;

    	%%% Pick the onset on CF 

        [ind_pick,vals_kurto]=follow_extrem2(CF_time,...
             PickerParam.max_drift*rsample,flag_plot(3));

        if isempty(ind_pick)
            fprintf(1,'WARNING: not S phase found for station %s\n',station);
            continue
        end
        
        %%% Feed pick array
        
        ind_S=ind_pick;

        %%% Compute max SNR

        window_snr=[2 2];
        LTA_snr=PickerParam.SNR_wind(1);
        STA_snr=PickerParam.SNR_wind(2);
        smooth_snr=5;

        fil_trace_S=filterbutter(3,PickerParam.SNR_freq(1),PickerParam.SNR_freq(2),rsample,trace_P);
        [snr,max_ind,max_snr]=snr_function(abs(cf_S),...
            rsample,LTA_snr,STA_snr,smooth_snr,...
            ind_S-window_snr(1)*rsample,ind_S+window_snr(2)*rsample,flag_plot(3));
        
        max_snr_n=max_snr;
        
        %%% Compute max Kurto
        
        max_kurto_n=quantile(vals_kurto,4);
    
        %%% Select best pick based on SNR or KURTO

        if strcmp(PickerParam.weight_switch,'SNR')

            boolean_snr_S=(max_snr_n>=PickerParam.SNR2W_S(1) &...
                max_snr_n==max(max_snr_n));
            if ~any(boolean_snr_S)
                weight_S=4;
                ind_S=[];
            else
                weight_S=get_weight(max(max_snr_n),PickerParam.SNR2W_S);
                ind_S=ind_S;
            end

        else

            boolean_kurto_S=(max_kurto_n>=PickerParam.KURTO2W_S(1) &...
                max_kurto_n==max(max_kurto_n));
            if ~any(boolean_kurto_S)
                weight_S=4;
                ind_S=[];
            else
                weight_S=get_weight(max(max_kurto_n),PickerParam.KURTO2W_S);
                ind_S=ind_Sn(boolean_kurto_S);
            end

        end

    end
    
    %%%%%%%%%%%%%%
    %%% Store Picks in Event structure
    
    % for P
    
    PHASES(ind_Pphase).ARRIVAL=rela2abs(ind_P,t_begin,rsample);
    PHASES(ind_Pphase).WEIGHT=weight_P;
    
    % for S
    if pick_flag_S==1

        PHASES(ind_Sphase).ARRIVAL=rela2abs(ind_S,t_begin,rsample);
        PHASES(ind_Sphase).WEIGHT=weight_S;
        
    end
    
  
    %% Figure

    if flag_plot(2)

        figure(1)

        filt_P=filterbutter(3,...
        PickerParam.Station_param.(DATA(iter).STAT).pick.P.Kurto_F(1,1),...
        PickerParam.Station_param.(DATA(iter).STAT).pick.P.Kurto_F(1,2),...
        rsample,trace_P);
   
        xax=(1:length(trace_P))/(rsample);
        
        %%% Plot P
        
        h1=subplot(2,1,1);      
        plot(xax,filt_P/max(filt_P),'k');
        title('Trace used for P-pick')
        hold on
        if ~isempty(ind_P)
            xmin=first_sample/rsample;
            xmax=last_sample/rsample;

            dmin=-0.8;
            dmax=+0.8;
            patch([xmin xmax xmax xmin xmin],[dmin dmin dmax dmax dmin],-.1*ones(1,5),[.9 0.8 0.8],'EdgeColor','k')

            plot([ind_P ind_P]/rsample,[dmin dmax],'Color','b');
                     
            ts=abs2rela(time_P,t_begin,rsample);
            plot([ts ts]/rsample,[dmin dmax],'--b');
        end
        hold off
        
        %%% Plot S
        
        if ~isempty(trace_S)
            
                 filt_S=filterbutter(3,...
        PickerParam.Station_param.(DATA(iter).STAT).pick.S.Kurto_F(1,1),...
        PickerParam.Station_param.(DATA(iter).STAT).pick.S.Kurto_F(1,2),...
        rsample,trace_S);
    
            h1bis=subplot(2,1,2);

            plot(xax,filt_S/max(filt_S),'k');
            title('Trace used for S-pick');
        end

        if ~isempty(ind_S)
            
          
            hold on
            xmin_S=first_sample_S/rsample;
            xmax_S=last_sample_S/rsample;
            dmin=-1;
            dmax=+1;
            patch([xmin_S xmax_S xmax_S xmin_S xmin_S],[dmin dmin dmax dmax dmin],-.1*ones(1,5),[.9 .9 .9],'EdgeColor','k','facealpha',0.7)

            plot([ind_S ind_S]/rsample,[dmin dmax],'Color','r');
            ts=abs2rela(time_S,t_begin,rsample);
            plot([ts ts]/rsample,[dmin dmax],'--r');
    
        end
        

    end
    

    if flag_plot(2)
        fprintf(1,'Station: %s\n',station);
        keyboard
        close all
    end

end

EVENT.PHASES=PHASES;

%%% Relocate 
new_event=comp_THEO(hyp,EVENT);
new_event.COLOR=[1 0 0];
S.DATA=DATA;
S.EVENTS=new_event;

%%% Plot if asked

if flag_plot(1)
    plot_DATA(S);
end


end

