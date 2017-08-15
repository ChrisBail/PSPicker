% function made to clean some phases with big residuals 
% (i.e. put a weight 4 for phases that present residuals bigger than
%     a user defined threshold)
%
% Input:
%     IN: EVENT structure containing phases
%     rms_thres: RMS threshold to put 4 weight
%     hyp: hypocenter program path
%     
% Output:
%     OUT: EVENT structure with bad phases put to 4;
% 

function OUT=rmres_EVENT(IN,rms_thres,hyp,show)

%%% Initialize OUT EVENT structure

OUT=init_EVENT(numel(IN));

%%% Start process

for i=1:numel(IN)

    EVENT=IN(i);
    
    %%% Check that IN is an EVENT structure
    
    if ~check_EVENT(EVENT)
        continue
    end
    
    %%% Process the phases to remove bad rms
    
    PHASES=EVENT.PHASES;
    
    %%% Check that Phase not empty
    
    if isempty_PHASE(EVENT.PHASES)
        continue
    end
    
    for j=1:numel(PHASES)
        if abs(PHASES(j).RMS)>rms_thres
            PHASES(j).WEIGHT=4;
        end
    end
    
    EVENT.PHASES=PHASES;
    
    %%% Recompute the event
    
    EVENT=comp_THEO(hyp,EVENT,show);
    
    %%% Store
    
    OUT(i)=EVENT;
     
end
    
end
