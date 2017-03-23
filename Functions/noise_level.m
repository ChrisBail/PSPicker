%%% Function made to get the noise level from any types of function
% Input:
%     data: raw data on which to compute level
%     first_sample: first_sample to extract the data
%     last_sample: last_sample to extract the data
%     smooth: smooth chosen, counted in number of samples
%     percent_thres: made to determine the threshold, percent*max=threshold
%     
% Output:
%     level: noise level
%     out: output data extracted 
%
% Example:
%     level=noise_level(data,5000,10000,100,0.4)
    
function [level,out]=noise_level(data,first_sample,last_sample,smooth,percent_thres,flag_plot)

    C=smooth_filtfilt(data,smooth);
    %C=filter(ones(1,smooth)/smooth,1,data);
    D=same_inc(C,first_sample,last_sample);
    D=D-min(D);
    thres_snr=max(D)*percent_thres;  
    A=D-thres_snr;
    A=A(A>0);
    A(isnan(A))=[];
    B=D;
    B(isnan(B))=[];
    ratio=(length(A)/length(B))*100; % ratio of what is above threshold over total
    level=ratio;
    out=D;
    
    if flag_plot
        figure
        ax1=subplot(2,1,1);
        hold on
        [x_patch,y_patch]=borders2patch([first_sample last_sample],[min(C) max(C)]);
        patch(x_patch,y_patch,'r','FaceAlpha',0.5);
        plot(C)
        hold off
        ax2=subplot(2,1,2);
        hold on
        plot(out);
        plot([first_sample last_sample],[thres_snr thres_snr],'k');
        text_str=sprintf('%f',thres_snr);
        text([first_sample+last_sample]/4,0.8*thres_snr,text_str);
        text_str=sprintf('%.0f%% of signal is above threshold',level);
        text(1*[first_sample+last_sample]/2,1.2*thres_snr,text_str);
        hold off
        linkaxes([ax1,ax2],'x')
    end
    
end