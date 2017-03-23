% Function made to get the maximum in a user defined window
% 
% Input:
%     first_sample: first sample of the window
%     last_sample: last sample of the window
%     data: input array
%     
% Output:
%     MAX: maximum value
%     IND: maximum index
%     
% Example:
%     [MAX,IND]=max_window(first_sample,last_sample,trace,flag_plot)

function [MAX,IND]=max_window(first_sample,last_sample,data,flag_plot)

[first_sample,last_sample]=check_samples(first_sample,last_sample,data);

%%% Compute

[MAX,IND_sc]=max(data(first_sample:last_sample));
IND=IND_sc+first_sample-1;

%%% Plot if asked

if flag_plot
   figure;hold on;
   plot(data,'k');
   [x_patch,y_patch]=borders2patch([first_sample last_sample],[min(data) max(data)]);
   p_obj=patch(x_patch,y_patch,'k','facealpha',0.2);
   set(p_obj,'edgecolor','none');
   plot([IND IND],[0 MAX],'r','linewidth',2);
   hold off
end


end

