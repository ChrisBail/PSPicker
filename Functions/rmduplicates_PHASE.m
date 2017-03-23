% function made to remove duplicate phases form a PHASE structure, it means that
% it will remove phases that have same station name and same phase, for example
% station STA has two P phases (which is not possible). This program was made because
% the binder from Rietbrocks may output same phases for a single station (BUG)
% 
% Input:
%     IN: PHASE structure
% 
% Output:
%     OUT: PHASE stucture with duplicates removed
% 

function OUT=rmduplicates_PHASE(IN)

station={IN(:).STATION}';
type={IN(:).TYPE}';

%%% Concatenate cell

concat=strcat(station,{' '},type);

%%% Find duplicates

[~,~,ind]=unique(concat); % Find the indices of the unique strings
ind_dup=ind_duplicates(ind);

%%% Remove duplicates

OUT=IN;
OUT(ind_dup)=[];

end