% function made to check if gaps exist in the trace

function [boolean_gaps,len_gaps,num_gaps,ind_beg,ind_end]=isgap(trace,limit,gap_value,first_sample,last_sample,flag_plot)

% A=load('gap_trace.mat','A');
% trace=A.A;
% trace(3500:3700)=0;

%%% Parameters

% flag_plot=1;
% limit=20;
% gap_value=0;
% first_sample=1550;
% last_sample=1800;

%%% Initialize 

boolean_gaps=false;

%%% Check input arguments

if ~exist('first_sample','var')
    first_sample=1;
end

if ~exist('last_sample','var')
    last_sample=numel(trace);
end

if ~exist('flag_plot','var')
    flag_plot=0;
end

if first_sample<1
    first_sample=1;
end
if last_sample>numel(trace)
    last_sample=numel(trace);
end

%%% Process

trace_cut=trace(first_sample:last_sample);
gap_f=nan(numel(trace_cut),1);
gap_f(trace_cut==gap_value)=1;
gap_f(trace_cut~=gap_value)=0;
gap_f(1)=0;
gap_f(end)=0;

a=diff(gap_f);

ind_beg=find(a==1)+first_sample;
ind_end=find(a==-1)+first_sample-1;

%%% Get outputs

len_gaps=ind_end-ind_beg;
num_gaps=length(len_gaps);

if any(len_gaps>limit)
    boolean_gaps=1;
end

%%% Plot if requested

if flag_plot
    f=figure;
    hold on
    
    [x_patch,y_patch]=borders2patch([first_sample last_sample],[-1 1]);
    patch(x_patch,y_patch,[1 0 0],'EdgeColor','none','Facealpha',0.3)
    
    trace=norm_data(trace);
    plot(trace)
 
    for i=1:num_gaps
        [x_patch,y_patch]=borders2patch([ind_beg(i) ind_end(i)],[-1 1]);
        patch(x_patch,y_patch,[1 1 1]*0.5,'EdgeColor','none')
        text([ind_beg(i)+ind_end(i)]/2,0,sprintf('%i',len_gaps(i)),'Horizontalalignment','center');
    end
    
    hold off
end






