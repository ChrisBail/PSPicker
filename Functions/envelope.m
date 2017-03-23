% function made to compute the enveloppe of an array, and smooths by a selected time window
% Input:
%     f: array
%     smooth: number of samples for smoothin
%     type: 'maxi' or 'mini'
%     
% Output:
%     f_out: smoothed envelope

function f_out=envelope(f,smooth,type)

y = diff(sign(diff(f)));

if strcmp(type,'maxi')
    max_loc = [0;y < 0;0];
    Fmax = find(max_loc == 1);
    indice=Fmax;
else 
    min_loc = [0;y > 0;0];
    Fmin = find(min_loc == 1);
    indice=Fmin;
end

value=f(indice);

%%% Interp

xt=1:length(f);
xt=xt';

yt=interp1(indice,value,xt);

%%% Apply smoothing

f_out=smooth_filter(yt,smooth);

end









