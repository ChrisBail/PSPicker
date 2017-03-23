% function made to check which traces of a given DATA structure pass the 
% SNR test around a given phase 
% 
% Input:
%     IN: DATA structure associated to 1 station
%     SNR_PARAM: structure containing all the necessary parameters (see 
%     init_TESTSNR for more info).
%        time_phase should be given in matlab datenum
%        window, LTA, STA should be given in seconds
%     flag_plot: 0 or 1
%     
% Output:
%     boolean_test:
%     max_snr:
%     SNR:
%      
%  Example:
%     [a,b,c]=pass_SNRTEST(DATA,SNR_PARAM)

function [boolean_test,max_snr,SNR]=pass_SNRTEST(DATA,SNR_PARAM,flag_plot)
    
%%% Assign variables

LTA=SNR_PARAM.LTA;
STA=SNR_PARAM.STA;
time_phase=SNR_PARAM.time_phase;
window=SNR_PARAM.window;
threshold=SNR_PARAM.threshold;
filter_band=SNR_PARAM.filter_band;

%%% Other parameters

smooth=1;
rsample=DATA.RSAMPLE;

%%% Build window

window(1)=time_phase-window(1)/86400;
window(2)=time_phase+window(2)/86400;

%%% Start process

max_snr=zeros(numel(DATA.RAW),1);

if flag_plot
    color_c={'r','g','b','k'};
    figure
end

tot_subplots=numel(DATA.RAW)+1;

for j=1:length(DATA.RAW)
    t_begin=DATA.RAW(j).TIMESTART;
    trace=DATA.RAW(j).TRACE;
    if exist('filter_band','var')
        trace=filterbutter(3,filter_band(1),filter_band(2),rsample,trace);
    end
    snr=snr_function(abs(norm_data(trace)),rsample,LTA,STA,smooth);
    first_sample=abs2rela(window(1),t_begin,rsample);
    last_sample=abs2rela(window(2),t_begin,rsample);
    if first_sample<1
        first_sample=1;
    end
    
    if last_sample>length(snr)
        last_sample=length(snr);
    end
    
    %%% Prepare outputs
   
    max_snr(j)=max(snr(first_sample:last_sample)); 
    SNR(j)={snr};
    
    %%% Plot if requested
    
    if flag_plot
        if j==length(DATA.RAW)
            subplot(tot_subplots,1,tot_subplots);hold on;
            [x_patch,y_patch]=borders2patch([first_sample last_sample],[0 max(max([SNR{:}]))
]);
            patch(x_patch,y_patch,'k','facealpha',0.2,'edgecolor','none');hold off;
        end

        ax(1)=subplot(tot_subplots,1,j);
        plot(norm_data(trace),'color',color_c{j})
        ax(2)=subplot(tot_subplots,1,tot_subplots);hold on;
        plot(snr,'color',color_c{j});hold off;
        linkaxes(ax,'x')
    end
   
end

%%% Check if it's over the threshold AND take the one with the
%%% biggest SNR
%%% Create boolean

boolean_test=(max_snr>threshold) & (max_snr==max(max_snr));

%%% if all pass the test and have same max (very very low probability)

if all(boolean_test)
    boolean_test(:)=0;
    boolean_test(1)=1;
end

%%% Remind Outputs

boolean_test;
max_snr;
SNR;

end


