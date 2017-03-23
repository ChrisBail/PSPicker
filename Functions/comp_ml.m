%%% fucntion made to compute local magnitudes, default parameters are take
%%% from seisan...
%%% Amplitudes are given in nm
%%% Distances are given in km

function mag_ml=comp_ml(amp,dist,varargin)

%%% Define defaults

default_parameters=[1 1.11 0.00189 -2.09];

p = inputParser;

addRequired(p,'amp',@isnumeric);
addRequired(p,'dist',@isnumeric);
addParamValue(p,'parameters',default_parameters,@isvector);

%%% Parse

parse(p,amp,dist,varargin{:});
amp=p.Results.amp;
dist=p.Results.dist;
parameters=p.Results.parameters;

%%% Compute mag

mag_ml=...
    parameters(1)*log10(amp)+...
    parameters(2)*log10(dist)+...
    parameters(3)*dist+...
    parameters(4);
       
end