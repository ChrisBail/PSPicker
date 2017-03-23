% function mace to initialize event structure, that means 
% the one containing info about the location and all the phases associated 
% to that location
% 
% Input:
%     len_events: size of the event structure
% 
% Output:
%     EVENT: EVENT structure
    

function EVENT=init_EVENT(len_events)

%%% Function made to initialize picks INO structure

if nargin==0
    len_events=10000;
end

EVENT(len_events).AGENCY=[];
EVENT(len_events).ID=[];
EVENT(len_events).LON=[];
EVENT(len_events).LAT=[];
EVENT(len_events).DEP=[];
EVENT(len_events).RMS=[];
EVENT(len_events).XERR=[];
EVENT(len_events).YERR=[];
EVENT(len_events).ZERR=[];
EVENT(len_events).ORIGIN=[];
EVENT(len_events).COLOR=[];
EVENT(len_events).MAG=[];

%%% Add phase structure with one PHASE

PHASES=init_PHASE(1);

for i=1:numel(EVENT)
    EVENT(i).PHASES=PHASES;
end


end

