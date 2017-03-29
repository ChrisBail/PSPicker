function []=test_functions()

clear all
close all

%%% Load trace

data_struct=load('trace_P.mat');

trace=data_struct.trace_P;

%%% Parameters

rsample=100;
first_sample=1500;
last_sample=1750;
% first_sample=2650;
% last_sample=2750;

tic
[A,B,C]=trace2FWkurto(trace,rsample,...
            [1 25],...
            [0.4 0.5 1 2 5],...
            1,first_sample,last_sample);
     toc
plot(Mean_M)
figure
plot(M)
figure
plot(filterbutter(3,1,25,rsample,trace))

kurto_modif=M(:,1);
figure;
plot(kurto_modif)
%%% Param
swindow_ext=100;
a=zeros(10000,1);

for i=1:size(M,2)
    [min_ind(i),max_amp(i)]=get_min(M(:,i),swindow_ext);
end

[a,b]=last_elementclus(min_ind,0)

end

function [index,value]=last_elementclus(data,swin_lim)

%%% Test

if swin_lim<0
    warning('Window given to follow picks is negative');
    swin_lim=20;
end

%%% Retrieve index and value

scr1=diff(data);
scr2=[0 scr1];
scr3=abs(scr2);
scr4=scr3>swin_lim;
scr5=find(scr4==1,1,'first');
if isempty(scr5)
    index=numel(data);
else
    index=scr5-1;
end
value=data(index);

end

function [min_ind,max_amp]=get_min(data,swindow_ext)
% Function made to retrieve min index and also amplitude of the maximum extrema
% 
% Input:  data > data analyzed (type: array)
%         swindow_ext > length of the window located to the right of the min to look for extrema
%         
% Output: min_ind > index of min (type:int)
%         max_amp > max amplitude (type:float)

%%% Get min index
[min_val,min_ind]=min(data);

%%% Test

if isempty(min_ind)
    return;
end

right_limit=min_ind+swindow_ext;

if right_limit>numel(data)
    right_limit=numel(data);
end
    
%%% Get max
scr=loca_ext(min_ind,right_limit,data,'maxi');

if isempty(scr)
    ext_val=data(right_limit);
    if isnan(ext_val)
        scr2=data(min_ind:right_limit);
        scr3=scr2(~isnan(scr2));
        ext_val=scr3(end);
    end
else
    ext_val=scr(:,2);
end

%%% Get diff
ext_diff=ext_val-min_val;
max_amp=max(ext_diff);

end

