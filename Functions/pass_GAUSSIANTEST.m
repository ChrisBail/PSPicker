% function made to check if the distribution is gaussian or not
% 
% Input:
%     DATA: DATA structure
%     GAUSSIAN_PARAM: GAUSSIAN PARAM structure
%     flag_plot: 0 or 1
%     
% Output:
%     boolean_gaussian
%     max_gradient

function [boolean_gaussian,max_gradient]=pass_GAUSSIANTEST(DATA,GAUSSIAN_PARAM,flag_plot)

% %%% Parameters
% 
% flag_plot=1;
% GAUSSIAN_PARAM.grad_threshold=10;
% GAUSSIAN_PARAM.time_phase=DATA.RAW(1).TIMESTART+70./86400;
% GAUSSIAN_PARAM.window=[10 10];

%%% Get Paramters

grad_threshold=GAUSSIAN_PARAM.grad_threshold;
time_phase=GAUSSIAN_PARAM.time_phase;
window=GAUSSIAN_PARAM.window;

%%% Initialize

boolean_gaussian=ones(numel(DATA.RAW),1);
max_gradient=zeros(numel(DATA.RAW),1);

%%% Start Process

rsample=DATA.RSAMPLE;

for j=1:numel(DATA.RAW)
    trace=DATA.RAW(j).TRACE;
    t_begin=DATA.RAW(j).TIMESTART;
    first_sample=abs2rela(time_phase-window(1)/86400,t_begin,rsample);
    last_sample=abs2rela(time_phase+window(2)/86400,t_begin,rsample);
    max_gradient(j)=maxgrad_histo(trace,first_sample,last_sample,flag_plot);
    if max_gradient(j)>=grad_threshold
       boolean_gaussian(j)=0;
    end
end

end
    