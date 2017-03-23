%%% Return the noise level of a trace, by computing the snr.
% the computed value represent the percentage of the trace that is above a threshold.
% If the ratio is > 40% it mains th signal is often above the threshold, the signal is thus 
% considered as noisy. It seems that it's more robust that computing how
% many times the snr function goes above the threshold (see "rate"
% variable)
% 
% Input:
%     DATA: Main structure containing data
%     PickerParam: Structure containing the MainParameters
%     
% Output:
%     OUT: structure with snr level
%     

function OUT=get_SNR(DATA,LTA,STA,filter_val)

% delay_sec_after=30;
% delay_sec_before=10;
smooth=100;

for iter=1:length(DATA)
    rsample=DATA(iter).RSAMPLE;
        
    for i=1:length(DATA(iter).RAW)
        
        t_begin=DATA(iter).RAW(i).TIMESTART;
        trace=DATA(iter).RAW(i).TRACE;
        
%         first_sample=1;
%         last_sample=1*length(trace);
%         
%         if ~isempty(DATA(iter).WINDOW_P);
%             time_start=DATA(iter).WINDOW_P(1);
%             first_sample=abs2rela(time_start,t_begin,rsample);
%             last_sample=first_sample+delay_sec_after*rsample;
%             first_sample=first_sample-delay_sec_before*rsample;
%             if last_sample>length(trace)
%                 last_sample=length(trace);
%             end
%             if first_sample<1
%                 first_sample=1;
%             end
%         end
           
        
%         [level,snr]=noise_level(trace,LTA,STA,rsample,filter_val,first_sample,last_sample);
       
        filt=filterbutter(3,filter_val(1),filter_val(2),rsample,trace);
        energy=sqrt(sum(filt.^2,2));
        snr=snr_function(energy,rsample,LTA,STA,smooth);
        DATA(iter).RAW(i).SNR=snr;
        
%         subplot(3,1,1)
%         plot(filt)
%         subplot(3,1,2)
%         plot(energy)
%         subplot(3,1,3)
%         plot(snr)
%         hold on
%         plot(C)
%         plot([1:length(C)],ones(length(C),1).*thres_snr,'--')
%         hold off

    end
end

OUT=DATA;

end