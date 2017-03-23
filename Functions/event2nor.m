% Function made to create a nordic file from an EVENT structure that
% may contain several events
% 
% Input:
%     EVENT: event structure (structure)
%     sfile_name: name of output nordic file (string)
%     
% Example:
%     event2nor(EVENT,'test.sfile')

function event2nor(EVENT,sfile_name)

%%% Check if only one single file

if numel(EVENT)==1
    event2nor_single(EVENT,sfile_name);
    return
end
    
%%% Create temp directory

if exist('./tmp_scratch','dir')
    rmdir('tmp_scratch','s')
end

mkdir('tmp_scratch');

%%% Create prefix to insure no doublons

prefix=datestr(now,'HHMMSS');

%%% create tmp file for

for i=1:numel(EVENT)
    filename=sprintf('./tmp_scratch/%s_EVENT_%06d.sfile',prefix,i);
    event2nor_single(EVENT(i),filename)
end

%%% Concatenate files

cmd=sprintf('cat ./tmp_scratch/%s_EVENT_*.sfile > %s',prefix,sfile_name);
system(cmd);

%%% Remove scratch directory

rmdir('tmp_scratch','s')

end


function event2nor_single(EVENT,sfile_name)

%%% Initialize

nor_struct=read_nor();

%%% If no origin, thake the first phase

if isempty(EVENT.ORIGIN)
    EVENT.ORIGIN=min([EVENT.PHASES(:).ARRIVAL]);
end

%%% Get time

[year,month,day,hour,minu,sec]=datevec(EVENT.ORIGIN);

%%% Get location

%%% Fill structure

nor_struct.year=year;
nor_struct.month=month;
nor_struct.day=day;
nor_struct.hour=hour;
nor_struct.min=minu;
nor_struct.sec=sec;
nor_struct.distanceindic='L';

nor_struct.lon=EVENT.LON;
nor_struct.lat=EVENT.LAT;
nor_struct.depth=-EVENT.DEP;
nor_struct.mag=EVENT.MAG;

nor_struct.ERROR.x=EVENT.XERR;
nor_struct.ERROR.y=EVENT.YERR;
nor_struct.ERROR.z=EVENT.ZERR;

nor_struct.rms=EVENT.RMS;

%%% Fill phases

num_arrivals=numel(EVENT.PHASES);
DATA=nor_struct.DATA;
DATA(num_arrivals)=DATA;

nor_struct.numbersta=numel(unique({EVENT.PHASES(:).STATION}));

k=0;

for i=1:num_arrivals
    if ~isempty(EVENT.PHASES(i).ARRIVAL)
        k=k+1;
        DATA(k).station=EVENT.PHASES(i).STATION;
        DATA(k).phase=EVENT.PHASES(i).TYPE;
        time_shift=(EVENT.PHASES(i).ARRIVAL-EVENT.ORIGIN);
        start=datenum([0 0 0 hour minu sec]);
        a=datevec(start+time_shift);
        hour_arrival=a(4)+24*a(3);
        min_arrival=a(5);
        sec_arrival=a(6);
        DATA(k).hour=hour_arrival;
        DATA(k).min=min_arrival;
        DATA(k).sec=sec_arrival;
        DATA(k).weight=EVENT.PHASES(i).WEIGHT;
        DATA(k).residual=EVENT.PHASES(i).RMS;
    end
    

    if ~isempty(EVENT.PHASES(i).AMP) && EVENT.PHASES(i).WRITE_FLAG==1
        k=k+1;
        DATA(k).station=EVENT.PHASES(i).STATION;
        DATA(k).phase='AMP';
        time_shift=(EVENT.PHASES(i).AMP_ARRIVAL-EVENT.ORIGIN);
        start=datenum([0 0 0 hour minu sec]);
        a=datevec(start+time_shift);
        hour_arrival=a(4)+24*a(3);
        min_arrival=a(5);
        sec_arrival=a(6);
        DATA(k).hour=hour_arrival;
        DATA(k).min=min_arrival;
        DATA(k).sec=sec_arrival;
        DATA(k).period=EVENT.PHASES(i).PERIOD;
        DATA(k).amplitude=EVENT.PHASES(i).AMP;
    end
    


end

%%% Remove undefined data

DATA(k+1:end)=[];

%%%

nor_struct.DATA=DATA;

%%% Write nor

write_nor(nor_struct,sfile_name)
end

