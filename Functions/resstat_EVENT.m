% Function made to retrieve residuals for each station from a PHASE structure
% 
% Input:  EVENT > EVENT structure
%         phase_type > cell array of phase type
%         
% Output: RES > Res structure
% 
% Example:    resstat_EVENT(EVENT,{'P' 'S'})
% 

function RES=resstat_EVENT(EVENT,phase_type)

%%% Initialize

RES=struct();

%%% Start loop
for i=1:numel(EVENT)
    PHASES=EVENT(i).PHASES;
    for j=1:numel(PHASES)
        type=PHASES(j).TYPE;
        if ~any(strcmp(type,phase_type))
            continue
        end
        station=PHASES(j).STATION;
        rms=PHASES(j).RMS;
        if isfield(RES,station) && ...
                isfield(RES.(station),type) && ...
                isfield(RES.(station).(type),'rms_array')

            RES.(station).(type).rms_array=[RES.(station).(type).rms_array;rms];

        else
            RES.(station).(type).rms_array=rms;
        end
    end

end

%%% Get median

stations=fieldnames(RES);
for i=1:numel(stations)
    station=stations{i};
    types=fieldnames(RES.(station));
   for  j=1:numel(types)
       type=types{j};
       RES.(station).(type).rms_median=median(RES.(station).(type).rms_array);
   end
end
    



