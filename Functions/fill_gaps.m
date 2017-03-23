% function to fill gaps of a time serie
% 
% Inputs:
%     time: time array in seconds
%     data: data array (whatever you measure)
%     rsample: sampling rate of the data
%     value: value that fill the gaps, can be NaN
%     
% Outputs:
%     new_time: new time array
%     new_data: filled data array

function [new_time,new_data]=fill_gaps(time,data,rsample,value)

dt=1/rsample;

new_time=[time(1):dt:time(end)]';

new_data=ones(numel(new_time),1)*value;

%%% To allow recognation

test_new=round(new_time*100);
test_old=round(time*100);

%%% Interesect

[bab,ia,ib] = intersect(test_new,test_old);

new_data(ia) = data(ib);

end

