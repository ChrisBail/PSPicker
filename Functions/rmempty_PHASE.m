% Function made to remove empty structures from info structure
% 
% Input:
%     IN : PHASE structure where empty elements needs to be removed
%     
% Output:
%     OUT : PHASE structure where empty elements have been removed
    
function OUT=rmempty_PHASE(IN)

%%% Check empty elements

ind_sel=isempty_PHASE(IN);

%%% Remove empty elements

OUT=IN;
OUT(ind_sel)=[];

end

