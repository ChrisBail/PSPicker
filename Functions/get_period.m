% function made to look for indice of the closest zeros in a trace around a
% focus index
% 
% Input:
%     data: data array
%     index_focus: index to look around
%     
% Output:
%     index_output: array of index (should be of size 1*2 if oscillator)
%     
  

function index_output=get_period(data,index_focus,flag_plot)

    %%% Checks

    if numel(index_focus)~=1
        error('Check index_focus, must be of length 1');
    end
    
    if (index_focus > numel(data)) || (index_focus < 1 )
        error('index focus is out of bounds');
    end

    data=data(:);
    
    %%% Check where signs change
    
    diff_array=[diff(sign(data));0];

    diff_array(diff_array~=0)=1;

    index=1:length(diff_array);
    index=index';

    index1=index(diff_array==1);

    dd=index_focus-index1;

    ind_left=max(index1(dd>0));
    ind_right=min(index1(dd<0));
    
    index_output=[ind_left ind_right];

    %%% Plot if asked
    
    if flag_plot
        figure;
        hold on
        plot(index_focus,max(data),'or','Markersize',4,'markerfacecolor','r')
        [x_patch,y_patch]=borders2patch(index_output,[min(data) max(data)]);
        p_obj=patch(x_patch,y_patch,'r','edgecolor','none');
        plot(data,'k');
        hold off
    end
    
    
end
