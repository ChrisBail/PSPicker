% get_Trace allows this user to recover the data from a DATA structure given the station name,components
% channel name
% 
% Inputs:
%     DATA: structure returned by get_DATA, contains all the data from an extractet events (required)
%     station: station name (required)
%     channel cell: cell containing desired channel {'SL' 'SH'} (optionnal)
%     components cell: cell containing desired channel {'Z' 'X'} (optionnal)
%     
%     ex: get_TRACE(DATA,'DANN','chan','SL') returns all components associated to channel SL
%         get_TRACE(DATA,'DANN','chan','SL','comp','X') returns only X component (if exists) ass. to channel SL
%         
% Outputs:
%     comp_select: cell with comp
%     chan_select: ""
%     trace_select: cell with data
%     trace_matrix: matrix with data
    

function OUT_DATA = select_DATA(DATA,station,varargin)

   p = inputParser;
   default_chan='1';
   default_channelID='1';
   default_comp='1';
   default_snr=100;
   default_flag_P=1;
  
   valifcn= @(x) ischar(x) || iscell(x); % You must define this fucntion otherwise it fails
   valifcn2= @(x) isnumeric(x);
   valifcn3= @(x) isnumeric(x) || ischar(x);
   addRequired(p,'DATA',@isstruct);
   addRequired(p,'station',@ischar);
   addParamValue(p,'chan',default_chan,valifcn);
   addParamValue(p,'channelID',default_channelID,valifcn);
   addParamValue(p,'comp',default_comp,valifcn);
   addParamValue(p,'snr',default_snr,valifcn3);
   addParamValue(p,'flag_P',default_flag_P,valifcn2);

   parse(p,DATA,station,varargin{:});
   
   ind_sta=find(strcmp(station,{DATA(:).STAT}'));
   if isempty(ind_sta)
       fprintf('\tThe station called %s is not in the strcuture given\n',station);
       chan_select=[];
       comp_select=[];
       trace_select=[];
       channelID_select=[];
       return
   end
   
   DATA_sta=DATA(ind_sta);
   RAW=DATA_sta.RAW;    % It's a structure
   
   %%% Check if optional arg are char or cell, put it into char if cell for
   %%% convenience
   
   chan=p.Results.chan;
   channelID=p.Results.channelID;
   comp=p.Results.comp;
   snr=p.Results.snr;
   flag_P=p.Results.flag_P;
   
   if ischar(chan)
       chan={chan};
   end
   if ischar(comp)
       comp={comp};
   end
   if ischar(channelID)
       channelID={channelID};
   end

   all_chan={RAW(:).CHAN};
   all_comp={RAW(:).COMP};
   all_channelID=strcat(all_chan,all_comp);
   
   if strcmp(chan,'1')
       chan={RAW(:).CHAN};
   end
   if strcmp(comp,'1')
       comp={RAW(:).COMP};
   end
   if strcmp(channelID,'1')
       channelID=all_channelID;
   end
   
   
   %%% Get data
   
   if isempty([RAW(:).NOISE])
       vec_snr=ones(1,length({RAW(:).CHAN}));
   elseif strcmp(snr,'lowest')
       vec_snr=([RAW(:).NOISE]==min([RAW(:).NOISE]));
   else
       vec_snr=[RAW(:).NOISE]<=snr;
   end
%    
%    if isempty(DATA_sta.FLAG_P)
%        vec_flag_P=ones(1,length(DATA_sta.CHAN));
%    else
%        vec_flag_P=DATA_sta.FLAG_P;
%    end
   
   vec_chan=ismember({RAW(:).CHAN},chan);
   vec_comp=ismember({RAW(:).COMP},comp);
   vec_channelID=ismember(all_channelID,channelID);
   
   ind_select=find(vec_chan & vec_comp & vec_snr & vec_channelID);
   
   OUT_RAW=RAW(ind_select);
   OUT_DATA=DATA_sta;
   OUT_DATA.RAW=OUT_RAW;
   
       
   end

   