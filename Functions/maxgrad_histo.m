function [max_gradient,x_values,n_norm]=maxgrad_histo(trace,first_sample,last_sample,flag_plot)
% function made to compute the maximum gradient of the histogram to detect 
% strange variation of samples distribution. The maximum gradient is normalized
% by an extremum gradient where all samples are zeros, thus the gradient
% is 1 / delta(x), we normalized the trace before processing to ensure the min, max 
% of the trace is -1/+1. delta_x should not be changed and is equal to 0.01 (200 steps
% from -1 to 1). It is mainly designed to reject clipped trace, where
% samples amplitudes have common values
% 
% Input:
%     trace: trace to be processed
%     first_sample, last_samples: samples windowing the trace to be processed
%     flag_plot: 0 or 1, of you want to plot
%     
% Output:
%     max_gradient: maximum gradient of the histogram
%     
% Example:
%     max_gradient=maxgrad_histo(trace,1,numel(trace),1)
 


% a=load('tt');
% trace=a.tt;

%%% Paramaters

delta_x=0.01;
% first_sample=1000;
% last_sample=4500;
% flag_plot=1;

%%% Process Data

data=same_inc(trace,first_sample,last_sample);
data_stat=data(~isnan(data));
data_stat=data_stat-median(data_stat);
data_stat=norm_data(data_stat);

%%% Compute stat

x_values=-1:delta_x:1;
n=hist(data_stat,x_values);
n_norm=n./sum(n);

%%% Get gradient

gradient_n=diff(n_norm)./delta_x;
gradient_n_norm=gradient_n * delta_x*100;
max_gradient=max(gradient_n_norm);

%%% Start plot if asked

if flag_plot
    figure
    ax1=subplot(3,1,1);
    hold on
    [x_patch,y_patch]=borders2patch([first_sample last_sample],[min(data) max(data)]);
    patch(x_patch,y_patch,'r','FaceAlpha',0.5);
    plot(trace);
    hold off
    ax2=subplot(3,1,2);
    bar(x_values,n_norm)
    xlim([-1 1])
    ax3=subplot(3,1,3);
    plot(x_values(2:end),gradient_n);
    title_str=sprintf('Max gradient = %.1f',max_gradient);
    title(title_str)
    linkaxes([ax2 ax3],'x')
end

end
    

 


