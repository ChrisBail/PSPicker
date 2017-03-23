% This function is made to initialize PHASE structure, which is the main Structure
% to store phases info (amplutide, picks, SNR...)
% WRITE_FLAG parameter is used to decide or not if the phase has
% to be taken into account before writing it in a nordic file for example, at
% the beginning it set to 1 because we consider all phases are valid (a priori)
% 
% Input:
%     len_phases : size of the info structure
% 
% Output:
%     PHASE : Phase structure of length len_phase
    
function PHASE=init_PHASE(len_phases)

%%% Function made to initialize picks INO structure

if nargin==0
    len_phases=1000;
end

PHASE(len_phases).STATION=[];
PHASE(len_phases).CHAN=[];
PHASE(len_phases).TYPE=[];
PHASE(len_phases).ARRIVAL=[];
PHASE(len_phases).WINDOW=[];
PHASE(len_phases).THEO=[];
PHASE(len_phases).AMP=[];
PHASE(len_phases).AMP_ARRIVAL=[];
PHASE(len_phases).AMP_WINDOW=[];
PHASE(len_phases).PERIOD=[];
PHASE(len_phases).MAG=[];
PHASE(len_phases).WEIGHT=[];
PHASE(len_phases).RMS=[];
PHASE(len_phases).DIS=[];
PHASE(len_phases).SNR=[];
PHASE(len_phases).CLIP=[];
PHASE(len_phases).WRITE_FLAG=1;

end