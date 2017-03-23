% Function made to check if traces pass GAP_TEST
% 
% Input:
%     DATA: DATA structure containing channels info
%     GAP_PARAM: GAP structure, see below for fields
%     flag_plot: 1 or 0
%     
% Output:
%     boolean_test: array (n x 1) of validation (1 or 0)

function boolean_test=pass_GAPTEST(DATA,GAP_PARAM,flag_plot)

%%% Assign variables

limit=GAP_PARAM.limit;
gap_value=GAP_PARAM.gap_value;
time_phase=GAP_PARAM.time_phase;
window=GAP_PARAM.window;

%%% Other parameters

rsample=DATA.RSAMPLE;

%%% Build window

window(1)=time_phase-window(1)/86400;
window(2)=time_phase+window(2)/86400;

%%% Process

boolean_test=ones(numel(DATA.RAW),1);

for j=1:length(DATA.RAW)
    t_begin=DATA.RAW(j).TIMESTART;
    trace=DATA.RAW(j).TRACE;
    first_sample=abs2rela(window(1),t_begin,rsample);
    last_sample=abs2rela(window(2),t_begin,rsample);
    boolean_gaps=isgap(trace,limit,gap_value,first_sample,last_sample,flag_plot);
    boolean_test(j,1)=~boolean_gaps;
end

end