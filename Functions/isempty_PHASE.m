 % function made to return the indice of empty strcuture in PHASE structure
% 
% Input:
%     PHASE : PHASE structure to check if empty
%     
% Output:
%     ind_sel : indices of empty structures

function ind_sel=isempty_PHASE(IN)

%%% Check if structure is PHASE structure 
    
if ~check_PHASE(IN)
    disp('Structure given is not an PHASE structure');
    return;
end

%%% Initalize empty PHASE model structure for comparison

EMPTY_PHASE=init_PHASE(1);

%%% Check trough loops

ind_sel=nan(numel(IN),1);
for i=1:numel(IN)
    if isequal(IN(i),EMPTY_PHASE)
        ind_sel(i)=i;
    end    
end

%%% Remove Nans

ind_sel(isnan(ind_sel))=[];

end
