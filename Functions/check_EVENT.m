% function made to check if a structure is trully an EVENT structure
% If not the glag returned is zero
% 
% Input:
%     IN : structure to be checked
%     
% Output:
%     flag : returned flag, false if IN isn't an EVENT structure, true otherwise
        
function flag=check_EVENT(IN)

%%% Iniatlize EVENT model structure for comparison

EVENT_MODEL=init_EVENT(1);

%%% Check fieldnames do declare structure as EVENT

if numel(fieldnames(IN))~=numel(fieldnames(EVENT_MODEL)) || ...
        ~all(strcmp(fieldnames(IN),fieldnames(EVENT_MODEL)))
    disp('Structure given doesn''t have EVENT fieldnames')
    flag=false;
else
    flag=true;
end

end




