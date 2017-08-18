%%% Main function made to compute picks and amplitude
% The user need only to specify which parameter files will be used 
% and also which station file will be used

clear all
close all

%%% Load Paths to functions

addpath(genpath('Functions'))

%%%%%%%%%%%%%%%%%%
%%% Parameters %%%
%%%%%%%%%%%%%%%%%%

mainfile={'mainfile.txt'};
flag_plot=1;
rms_thres=4;
mstan=2;
limit_pha=4;
limit_dev=0.5;
debug=0;



%%%% Define global variables

global PickerParam

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Get nordic %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[PickerParam,flag_path]=readmain(mainfile{1}); 
if flag_path==0
    return
end
pz_file=PickerParam.station_PZ;
input_nordic=PickerParam.input_nordic;

%%% Check if input is file or directory and store in cell

if exist(input_nordic)==2 % file
    files_nor={input_nordic};
elseif exist(input_nordic)==7 % directory
    files_nor = dir( fullfile([input_nordic,'*.nor']));
    files_nor=cellfun(@(x) [input_nordic,x],{files_nor.name}','UniformOutput',false);
end

%%% Define log file

if exist('log_file.txt','file')
    delete('log_file.txt');
end

%%% Create tmp directory for all tmp files

if ~exist('./tmp')
    mkdir('./tmp');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Start loop over nordic files %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:numel(files_nor)
    
    close all
    
    filenor=files_nor{i};
    
    %%% Read events

    EVENTS=nor2event(filenor);

    %%%% Start loop over events %%%%
    
    for j=1:numel(EVENTS)
        
        fac=fopen('log_file.txt','at');
        clearvars -except ME EVENT mainfile filenor fac files_nor i pz_file flag_plot rms_thres ...
        mstan limit_pha limit_dev debug dir_input_nordic j EVENTS
        
        %%% Message
        
        fprintf(1,'Processing EVENT %s\n',EVENTS(j).ID);
        fprintf(fac,'Processing EVENT %s\n',EVENTS(j).ID);
    
        try

            %%% Choose one event

            EVENT=EVENTS(j);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%% PICKING PROCESS %%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% (1) Initial cleaning and relocation of events %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%% Check if we have primer location

            if isempty(EVENT.LON)
                continue
            end

            %%% Readmain

            PickerParam=readmain(mainfile{1}); 
            hyp=PickerParam.hyp;
            
            %%% Apply weight of 2 on all S by default
            
            [~,ind_S]=get_PHASE(EVENT.PHASES,'type','S');
            [EVENT.PHASES(ind_S).WEIGHT]=deal(2);

            %%% 2) Extract Data (nood really need, only for plotting)

            [DATA,S]=extract_DATA(EVENT,mainfile{1},debug);
            if isempty(DATA)
                continue
            end
            if debug; plot_DATA(S);keyboard;end

            %%% 3) Clean event and relocate

            [EVENT_B,a,b]=rmsta_EVENT(EVENT,mainfile{1},mstan,limit_pha,limit_dev,0,debug);
            EVENT_C=rmres_EVENT(EVENT_B,rms_thres,hyp,debug);
            if isempty(EVENT_C.LON)
                continue
            end
            S.EVENTS=EVENT_C;
            if debug; plot_DATA(S);keyboard;end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% (2) Loop over mainfiles for refinement %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            for k=1:numel(mainfile)
                
                %%% Refine picks 

                S=refine_PICKS(EVENT_C,mainfile{k},0);
                if debug; plot_DATA(S);keyboard;end

                %%%  Clean event and relocate

                EVENT_D=S.EVENTS;
                [EVENT_E,station_reject,new_res]=rmsta_EVENT(EVENT_D,mainfile{k},mstan,limit_pha,limit_dev,1,debug);
                EVENT_F=rmres_EVENT(EVENT_E,rms_thres,hyp,debug);
         
                if isempty(EVENT_F.LON)
                    continue
                end

                S.EVENTS=EVENT_F;
                if debug; plot_DATA(S);keyboard;end
                
                EVENT_C=EVENT_F;
            
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%% 3) AMPLITUDE PROCESS %%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            S=amp_EVENT(EVENT_C,mainfile{1},pz_file,0);
            EVENT_C=S.EVENTS;
            if debug; plot_DATA(S);keyboard;end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%% WRITE Nordic file %%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%% Define nordic output filename from ID
            output_nordic=[datestr(EVENT_C.ID,'YYYY_mm_dd_HHMMSS'),'.nor'];

            %%% Define path

            sfile_folder=PickerParam.sfile_folder;
            year_folder=output_nordic(1:4);
            month_folder=output_nordic(6:7);

            path_nordic=[pwd,'/',sfile_folder,'/',year_folder,'/',month_folder,'/'];

            %%% Check if path exists

            if ~exist(path_nordic,'dir')
                mkdir(path_nordic)
            end

            %%% Write nordic

            event2nor(EVENT_C,output_nordic)

            %%% Movefile

            movefile(output_nordic,path_nordic)

        catch ME
            warning('Problem for EVENT %s\n',EVENTS(j).ID);
            fprintf(fac,'Problem for EVENT %s %i\n',EVENTS(j).ID,j);
            fprintf(fac,'%s\n',ME.message);
            for k=1:length(ME.stack)
                fprintf(1,'%s\n',ME.message);
                fprintf(1,'%s\n%i\n',ME.stack(k).name,ME.stack(k).line);
                fprintf(fac,'%s\n%i\n',ME.stack(k).name,ME.stack(k).line);
            end
        end
      fclose('all');
    end
    fclose('all');
end






