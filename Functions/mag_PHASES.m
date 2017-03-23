% Function made to compute local magnitudes for all phases present in PUASES ,structure
% If distance exists and amplitudes exist then it will compute magnitudes
% 
% Input:
%     PHASES: Phases structure (see init_PHASES) with amplitudes
%     station_file: STATION0.HYP type file (seisan) to get mag parameters
%     
% Output: 
%     OUT_PHASES: Phases with local magnitudes
%     

function [OUT_PHASES,new_mag]=mag_PHASES(PHASES,varargin)

%%% Parse 

p = inputParser;

addRequired(p,'PHASES',@isstruct);
addOptional(p,'station_file',0,@ischar);

parse(p,PHASES,varargin{:});
PHASES=p.Results.PHASES;
station_file=p.Results.station_file;

if station_file~=0
    %%% Read station0
    TEST=param_STATION0(station_file);
    mag_param=TEST(75:78);
end

%%% Compute Magnitude for all stations

for i=1:numel(PHASES)
    if ~isempty(PHASES(i).AMP) && ~isempty(PHASES(i).DIS)
        
        if station_file~=0
            %%% Compute mag

            PHASES(i).MAG=comp_ml(PHASES(i).AMP,PHASES(i).DIS,...
            'parameters',mag_param);
        else
            PHASES(i).MAG=comp_ml(PHASES(i).AMP,PHASES(i).DIS);
        end
  
    else
        PHASES(i).MAG=[];
    end
end

OUT_PHASES=PHASES;
new_mag=mean([PHASES.MAG]);

end