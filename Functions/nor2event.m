% Function made to read nordic files (.nor, see SEISAN for format) into an 
% EVENT structure used by Refine_picks and amp_DATA.
% 
% Input:
%     sfile_name : Sfile (nordic) name (type: string)
%     
% Output:
%     EVENT : Event structure (type: struct)

function EVENT=nor2event(sfile_name)

%%% Initialize waitbar

h = waitbar(0,'Please wait...storing records into structure');

%%% Initialize EVENT

EVENT=init_EVENT();

%%% Read sfile

NOR=read_nor(sfile_name);

%%% Loop over events

for i=1:numel(NOR)
    waitbar(i/numel(NOR));
    EVENT(i)=norstruct2EVENT(NOR(i));
end

%%% Remove empty events

EVENT=rmempty_EVENT(EVENT);

%%% Closing waitbar

close(h) 

end

function event=norstruct2EVENT(nor_struct)
    
event=init_EVENT(1);

%%% Read sfile

DATA=nor_struct.DATA;

%%% Fill structure

event.ID=datestr(nor_struct.datenum,'yyyy-mm-dd HH:MM:SS');
event.LON=nor_struct.lon;
event.LAT=nor_struct.lat;
event.DEP=-nor_struct.depth;
event.ORIGIN=nor_struct.datenum;
event.XERR=nor_struct.ERROR.x;
event.YERR=nor_struct.ERROR.y;
event.ZERR=nor_struct.ERROR.z;
event.RMS=nor_struct.rms;
event.MAG=nor_struct.mag;

num_arrivals=numel(nor_struct.DATA);

%%% Abort if num_arrivals=0

if num_arrivals==0
    PHASES=init_PHASE(1);
    event.PHASES=PHASES;
    return
end

%%% Initialize cells and arrays

PHASES=init_PHASE(num_arrivals);

%%% Get time

year=nor_struct.year;
month=nor_struct.month;
day=nor_struct.day;

for i=1:num_arrivals
    PHASES(i).STATION=DATA(i).station;
    PHASES(i).TYPE=DATA(i).phase;
    PHASES(i).ARRIVAL=datenum([year month day DATA(i).hour DATA(i).min DATA(i).sec]);
    PHASES(i).RMS=DATA(i).residual;
    PHASES(i).WEIGHT=DATA(i).weight;
    PHASES(i).AMP=DATA(i).amplitude;
    PHASES(i).PERIOD=DATA(i).period;
    PHASES(i).DIS=DATA(i).distance;
end

%%% Store Data
event.PHASES=PHASES;

end

