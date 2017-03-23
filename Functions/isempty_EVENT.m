 % function made to return the indice of empty strcuture in EVENT structure
% 
% Input:
%     EVENT : EVENT structure to check if empty
%     
% Output:
%     ind_sel : indices of empty structures

function ind_sel=isempty_EVENT(IN)

%%% Check if structure is EVENT structure 
    
if ~check_EVENT(IN)
    disp('Structure given is not an EVENT structure');
    return;
end

%%% Initalize empty EVENT model structure for comparison

EMPTY_EVENT=init_EVENT(1);

%%% Check trough loops

ind_sel=nan(numel(IN),1);
for i=1:numel(IN)
    if isequal(IN(i),EMPTY_EVENT)
        ind_sel(i)=i;
    end    
end

%%% Remove Nans

ind_sel(isnan(ind_sel))=[];

end
