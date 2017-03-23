% Function made to remove empty structures from info structure
% 
% Input:
%     IN : EVENT structure where empty elements needs to be removed
%     
% Output:
%     OUT : EVENT structure where empty elements have been removed
    
function OUT=rmempty_EVENT(IN)

%%% Check empty elements

ind_sel=isempty_EVENT(IN);

%%% Remove empty elements

OUT=IN;
OUT(ind_sel)=[];

end

