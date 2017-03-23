function [mean_M,C]=trace2FWkurto(f,h,FB,T,n_smooth,first,last) 
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
n=size(FB,1);
m=size(T,1);
l=m*n;
fri=size(f,2);
dsample=1/h;
nsample=size(f,1);
if last>nsample
    last=nsample;
end
if first<1
    first=1;
end
Nwin=floor(T/dsample);

%%% Trace filtering

k=1;
M=NaN(nsample,size(f,2),n*m);
Mf=M;
B=[];
C=[];
for i=1:n
   A=filterbutter(3,FB(i,1),FB(i,2),h,f);
  % A=same_inc(A,first,last);
   B=[B A];
end
for j=1:m
    % WCC: make sure that the kurtosis window isn't longer than the data window
%     if Nwin(j) > (last-first),
%         warning('Window length (%2gs) > selected data window (%4gs), skipping!',Nwin(j)/h,(last-first)/h);
%     %elseif Nwin(j) > (last-first)/2,
%     %    warning('Window length (%2gs) > 1/2 selected data window (%4gs)',Nwin(j)/h,(last-first)/h);
    
        %%% Strip B properly
        
        first_new=round(first-Nwin(j));
        if first_new<1
            first_new=1;
        end
        D=same_inc(B,first_new,last);
        kurtos=fast_kurtosis(D,Nwin(j));
        %V=find(~isnan(kurtos),1,'first')
        f_kurto_cum=smooth_filter(kurtos,n_smooth); % Smoothing if any
        kurto_cum=f_cumul(f_kurto_cum);     % Cumulative computation
        %corr_kurto_cum=drape_correction(kurto_cum); % New correction more efficient 17/11/2015
        line=f_segment(kurto_cum);          % Calculation of the straight line
        corr_kurto_cum=kurto_cum-line;      % Lineary corrected kurtosis
        C=[C corr_kurto_cum];
    
end
% Nanmat=ones(size(C));
% Nanmat(isnan(C))=0;
% Nanmat=sum(Nanmat,2);
mean_M=sum(C,2)./(l*fri);
% C(isnan(C))=0;
% mean_M=sum(C,2)./Nanmat;
end

