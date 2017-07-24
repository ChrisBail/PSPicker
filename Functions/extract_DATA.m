% Function made to extract the MSEED from an event and an SDS archive
% 
% Input:
%     EVENT: event structure
%     mainfile: picking mainfile
% 
% Ouptut:
%     DATA
%     S

function [DATA,S]=extract_DATA(EVENT,mainfile,show)

%%% Get path and paramters

PickerParam=readmain(mainfile);

hyp=PickerParam.hyp;
delay_before=PickerParam.extract_time(1);
delay_after=PickerParam.extract_time(1);
mseed_file='./tmp/cat.mseed';

%%% Get List of stations to be processed from mainfile

stations=fieldnames(PickerParam.Station_param);
stations_str=strjoin(stations);

channels=chanlist_PARAM(PickerParam);
channels_str=strjoin(channels);

%%% Compute theo

EVENT=comp_THEO(hyp,EVENT,show);

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
   start_time_str,end_time_str,stations_str,channels_str,PickerParam.sds_path,mseed_file);

[~,~]=system(['sds2mseed.sh',' ',cmd]);
movefile('scratch.file','./tmp/scratch.file');

%%%%%%%%%%%%%%%%%%
%%% Read file %%%%
%%%%%%%%%%%%%%%%%%

X=rdmseed(mseed_file);
S=get_DATA(X);
DATA=S.DATA;
S.EVENTS=EVENT;


end

