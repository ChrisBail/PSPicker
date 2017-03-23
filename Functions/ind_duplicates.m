% function made to get the indices of duplicates in a array of scalar
% 
% Input:
%     IN: array of scalar
% 
% Output:
%     OUT: indices of duplicates
    
function OUT=ind_duplicates(IN)

[n, bin] = histc(IN, unique(IN));
multiple = find(n > 1);
OUT = find(ismember(bin, multiple));

end