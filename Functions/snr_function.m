function [snr,max_ind,max_value]=snr_function(M,samplefreq,window_before,window_after,smooth,first_sample,last_sample,flag_plot)
% Returns estimated signal to noise ratio (dB)
% at time t, returns 20*log10(M(t...t+window_after)/M(t-window_before,t))
% M should therefore be energy(?)

%%% Check first that the absolute value is taken

if any(any(M<0))
    fprintf(1,'WARNING input contains negative values\n');
    M=abs(M);
end 

%%% Check parameters
m=size(M,1);
n=size(M,2);

%%% Check parameters

if ~exist('flag_plot','var')
    flag_plot=0;
end

if ~exist('first_sample','var') | first_sample<1
    first_sample=1;
end

if ~exist('last_sample','var') | last_sample>m
    last_sample=m;
end

f=samplefreq;
wb=round(window_before*f);
wa=round(window_after*f);

%%% Correct shift

% M=M-mean(M);

Ab=filter(ones(1,wb)/wb,1,M);
Aa=filter(ones(1,wa)/wa,1,M);

% Shift times correctly from half the size of both windows

Ba=[Aa(wa:end,:) ; nan(wa-1,n)];
Bb=Ab;
snr=abs(Ba./Bb);
%snr=20*log10(snr);  % This is what Christian uses, why?
snr(1:wb,:)=NaN;
snr(end-wa:end,:)=NaN;

%%% Filter output to smooth

snr=smooth_filter(snr,smooth);

%%% Get max_snr between first_sample and last_sample

max_value=zeros(n,1);
max_ind=zeros(n,1);

for i=1:n
    [max_value(i),max_ind(i)]=max(snr(first_sample:last_sample,i));
    max_ind(i)=max_ind(i)+first_sample-1;
end 

%%% Plot if asked

if flag_plot
    for j=1:n
        figure;
        x1=subplot(2,1,1);
        plot(M(:,j));
        x2=subplot(2,1,2);
        plot(snr(:,j));
        hold on;
        plot([max_ind(j) max_ind(j)],[min(snr(:,i)) max_value(j)]);
        [x_patch,y_patch]=borders2patch([first_sample last_sample],[min(snr(:,i)) max_value(j)]);
        patch(x_patch,y_patch,'k','facealpha',0.2,'edgecolor','none');
        hold off
        linkaxes([x1 x2],'x');
    end
end
