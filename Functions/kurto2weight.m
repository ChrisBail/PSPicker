% function made to compute the weight from 0 (best) to 4 (not used in hypo)
% Input:
%     std: value in sample of standard deviation
%     weight_sec: array containing seconds for weighting (ex: [0 0.2 0.5 1 3 5])
%     rsample: sampling of data
% Output:
%     weight: 0,1,2, 3 and 4

function w=kurto2weight(std,weight_sec)

%std2weight

% std=0;
% weight_sec=[0 0.2 0.5 1 3 5];
% rsample=50;
weight=0:4;

%% convert to sec

[c,d]=histc(std,weight_sec);

if all(c==0)
    w=weight(1);
else
    ind=find(c==1);
    w=weight(ind+1);
end
end
