function [ind_pick,vals_kurto]=follow_extrem2(CF,swin_drift,flag_plot)
% Function made to retrieve and track the minimum of each kurtosis characteristic function
% The function looks first for the global minimum on the kurtosis CF obtained with the larger window.
% Therefore it's really important that the CF in data are sorted from the larger kurtosis window to the smaller 
% kurtosis window. Once it has picked the global minimum, it tracks the minimum on the the more sensitive CF.
% The maximum drift allowed for looking to the left side of the global minimum is specfied
% by swin_drift. 
% 
% Input:  CF > Array containing sorted kurtosis CF in each column, from the larger window to the smaller window
%                 this Array is given by trace2FWkurto (type: array)
%         swin_drift > window size in sample to allow drift of the minimum (usually 10 samples is enough) (type:integer)
%         
% Output: ind_pick > final pick index (type:int)
%         vals_kurto > value of the max amplitude of the kurtosis for each CF (useful for weighting of the pick)
%         
% Example:    [ind_pick,vals_kurto]=follow_extrem2(CF_matrix,10) 

    %%% Parameters

    swindow_ext=100; % number of samples to the right of the pick to estimate kurtosis Amplitude

    %%% Test
    
    swin_drift=floor(swin_drift)+1;
    
    %%% Initializemax_amp=right_loca_max(data,left_limit,right_limit)

    vals_kurto=[];

    %%% Retrieve the first pick from the first CF (which should be associated
    %%% to the largest kurtosis window

    [first_pick_ind,~]=get_min(CF(:,1),swindow_ext);

    %%% Define left limit

    left_limit=first_pick_ind-swin_drift; % fixed

    follow_ind=[first_pick_ind];
    follow_val=[CF(first_pick_ind,1)];

    %%% Define first right limit

    right_limit=first_pick_ind;  % float

    %%% Start looping over CF

    for i=1:size(CF,2)

        data=CF(:,i);

        %%% Find loca ext to the left
        [ind_min_left,val_min_left]=left_loca_ext(data,...
            left_limit,right_limit,0);

        %%% Estimate kurto amplitude
        val_kurto=right_loca_max(data,left_limit,left_limit+swindow_ext);
        vals_kurto=[vals_kurto val_kurto];
        
        if isempty(ind_min_left)
            continue
        else
            right_limit=ind_min_left;
        end

        %%% feed element
        follow_ind=[follow_ind ind_min_left];
        follow_val=[follow_val val_min_left];
 

    end

    %%% Get pick

    ind_pick=follow_ind(end);

    %%% Plot if asked

    if flag_plot
        figure;
        plot(CF);
        hold on;
        plot(CF(:,1),'linewidth',2);
        plot(follow_ind,follow_val,'ok','markerfacecolor','k');
        plot(follow_ind(end),follow_val(end),'or','markerfacecolor','r');
        Ylim=get(gca,'YLIM');
        plot([left_limit left_limit],Ylim,'--k');
        hold off;
    end


end

function [index,value]=last_elementclus(data,swin_lim)
%Function made to find the last element closer than swin_lim

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
    [~,min_ind]=min(data);

    %%% Test

    if isempty(min_ind)
        return;
    end

    left_limit=min_ind;
    right_limit=min_ind+swindow_ext;

    if right_limit>numel(data)
        right_limit=numel(data);
    end

    max_amp=right_loca_max(data,left_limit,right_limit);

end

function max_amp=right_loca_max(data,left_limit,right_limit)
% Function made to estimate kurtosis amplitude

    %%% Test

    if right_limit>numel(data)
        right_limit=numel(data);
    end

    %%%
    min_val=data(left_limit);
    scr=loca_ext(left_limit,right_limit,data,'maxi');

    if isempty(scr)
        ext_val=data(right_limit);
        if isnan(ext_val)
            scr2=data(left_limit:right_limit);
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


function [ind_min_left,value_min_left]=left_loca_ext(data,left_limit,right_limit,flag_plot)
% Function made to find the local minimum in a given interval
% 
% Input:  data > curve (type: array)
%         left_limit > left limit in sample (type:int)
%         right_limit > right limit in sample (type:int)
% 
% Output: vertex of loca ext
        
    %%% Test

    if left_limit<1
        left_limit=1;
    end
    if right_limit>numel(data)
        right_limit=numel(data);
    end

    %%% Find loca ext
    scr=loca_ext(left_limit,right_limit,data,'mini');

    %%% Make sure that the right limit not included 
    scr(scr(:,1)>=right_limit,:)=[];

    %%% Get next minimum value
    [~,ind_scr]=min(scr(:,2));
    ind_min_left=scr(ind_scr,1);
    value_min_left=scr(ind_scr,2);

    %%% Plot if asked
    if flag_plot
       figure;
       plot(data)
       hold on;
       plot(ind_min_left,value_min_left,'or','markerfacecolor','r')
       plot([left_limit left_limit],[data(left_limit)-1 data(left_limit)+1],'--k');
       plot([right_limit right_limit],[data(right_limit)-1 data(right_limit)+1],'--k');
       hold off
    end

end
