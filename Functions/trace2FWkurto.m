function [CF_stack,CF_all,CF_time]=trace2FWkurto(f,h,FB,T,n_smooth,first,last) 
% trace2FWkurto calculates cumulative kurtosis over bandwidths and windows
%
% Usage:
%   [mean_M,C]=trace2FWkurto(f,h,FB,T,n_smooth,first,last)
%
% The FW in the name stands for Frequency Window because it computes for
% several frequency bandwidth and window sizes
%
% Input:    'f' is the raw trace (works on array, not on matrix)
%           'h' is the sampling frequency
%           'FB' is an n-by-2 matrix containing n frequency band
%                   specifications
%           'T' is an m-by-1 vector of window lengths (seconds)
%           'first' is the first sample of interest
%           'last' is ,the last sample of interest
% Ouput:    'M' is the (m*n)-by-(length(f)) kurtosis cumulative matrix
%           'sum_trace' is the mean value of the kurtosis for all windows
%           and all frequency bandwidth
% Example:  trace2FWkurto(f,100,[5 10;15 20],[1 2 3],10,1,1500)


%%% Check given parameters

if first==last
    fprintf(1,'Warning first_sample and last sample are equal to: %i \n',first)
end

%%% More parameters

T=T(:);

%%% Sort T to biggest to smallest so that output is sorted

T=sort(T,'descend');

%%% Get sizes

n=size(FB,1);
m=size(T,1);
num_traces=size(f,2);
l=m*n;

dsample=1/h;
nsample=size(f,1);

%%% Check

if last>nsample
    last=nsample;
end
if first<1
    first=1;
end
Nwin=floor(T/dsample);

%%% Start Loop 
A=[];
CF_time=[];
CF_all=[];

for i=1:n  
    %%% Loop on filters
    filter_trace=filterbutter(3,FB(i,1),FB(i,2),h,f);
    A=[A filter_trace];
end

for j=1:m
    filter_trace=A;
    first_new=round(first-Nwin(j));
    %%% Check
    if first_new<1
        first_new=1;
    end

    filter_trace=same_inc(filter_trace,first_new,last);
    kurto=fast_kurtosis(filter_trace,Nwin(j));
    kurto_smooth=smooth_filter(kurto,n_smooth); % Smoothing if any
    kurto_cum=f_cumul(kurto_smooth);     % Cumulative computation
    %corr_kurto_cum=drape_correction(kurto_cum); % New correction more efficient 17/11/2015
    line=f_segment(kurto_cum);          % Calculation of the straight line
    corr_kurto_cum=kurto_cum-line;      % Lineary corrected kurtosis
    stack_kurto_cum_freq=sum(corr_kurto_cum,2)./(n*num_traces);
    CF_time=[CF_time stack_kurto_cum_freq];
    CF_all=[CF_all corr_kurto_cum];

end

CF_stack=sum(CF_all,2)./(l*num_traces);

end

