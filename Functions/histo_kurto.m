% function made to compute the histo of the a slinding kurtosis to detect bad
% signals, a lot has still to be done on that, big potential. This function
% should be use on trace big enough to be statistically realistic
% 
% Input:
%     trace: trace to be processed
%     first_sample & last_sample: window to be processed
%     kurto_sample : window size counted in samples to process the kurtosis
%     pivot_value : value from which to compute the standard value (usually 1.5)
%     
% Output:
%     ratio_low:  ratio of samples under the pivot_value / total number of samples
%     std_value: 68 % of the samples are located between pivot_value and pivot_value + std_value
%     
% Example:
%     [ratio_low,std_value]=histo_kurto(trace,1,numel(trace),200,1.5,1)

function [ratio_low,std_value]=histo_kurto(trace,first_sample,last_sample,kurto_sample,pivot_value,flag_plot)

% trace=load('trace_11');
% trace_1=trace.trace;
% 
% %%% Paramaters
% 
% kurto_sample=100;
% pivot_value=1.5;

%%% Intialize

ratio_low=9999;
std_value=9999;

%%% Test paramters

first_sample(first_sample<1 || first_sample>numel(trace))=1;
last_sample(last_sample>numel(trace) || last_sample<1)=numel(trace);
if first_sample>=last_sample
    first_sample=1;
    last_sample=numel(trace);
end

%%% Compute Kurtosis

kurto=fast_kurtosis(trace,kurto_sample);
kurto=same_inc(kurto,first_sample,last_sample);

if numel(kurto(~isnan(kurto)))<20;
    fprintf(1,'Not enougth samples');
    return
end

xbins=0:0.05:max(kurto);
n=hist(kurto,xbins);

n_low=n(xbins<pivot_value);
n_up=n(xbins>=pivot_value);
x_low=xbins(xbins<pivot_value);
x_up=xbins(xbins>=pivot_value);

ratio_low=sum(n_low)./sum(n)*100;

%%% Check standard

a=cumsum(n_up)./sum(n_up);
[~,ind_a]=min(abs(a-0.68));
std_value=x_up(ind_a)-pivot_value;
max_xhisto = prctile(kurto,98);

%%% Start figure

if flag_plot
    
    figure

    h1=subplot(3,1,1);
    hold on
    [x_patch,y_patch]=borders2patch([first_sample last_sample],[min(trace) max(trace)]);
    patch(x_patch,y_patch,'g','edgecolor','none')
    [x_patch,y_patch]=borders2patch([0 kurto_sample],[min(trace) max(trace)]);
    patch(x_patch,y_patch,'r','edgecolor','none')
    plot(trace)
    box on
    hold off

    h2=subplot(3,1,2);
    plot(kurto)

    h3=subplot(3,1,3);
    hold on
    b1=bar(x_low,n_low,'r');
    set(b1,'edgecolor','none')
    b2=bar(x_up,n_up,'b');
    set(b2,'edgecolor','none')
    max_graph=max(n)+0.1*max(n);
    axis([0 max_xhisto 0 max_graph]);
    plot([pivot_value pivot_value],[0 max_graph]/2,'g');
    plot([pivot_value+std_value pivot_value+std_value],[0 max_graph]/2,'g');
    text_str=sprintf('ratio = %.1f',ratio_low);
    text(0,max_graph/1.2,text_str)
    text_str=sprintf('std = %.1f',std_value);
    text([pivot_value+std_value],max_graph/2,text_str);
    box on
    hold off
    linkaxes([h1,h2],'x');

end



