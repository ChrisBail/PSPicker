% function made to check if a structure is trully an PHASE structure
% If not the glag returned is zero
% 
% Input:
%     IN : structure to INe checked
%     
% Output:
%     flag : returned flag, false if IN isn't an PHASE structure, true otherwise
        
function flag=check_PHASE(IN)

%%% Iniatlize PHASE model structure for comparison

PHASE_MODEL=init_PHASE();

%%% Check fieldnames do declare structure as PHASE

if numel(fieldnames(IN))~=numel(fieldnames(PHASE_MODEL)) || ...
        ~all(ismember(fieldnames(IN),fieldnames(PHASE_MODEL)))
    disp('Structure given doesn''t have PHASE fieldnames')
    flag=false;
else
    flag=true;
end

end





