% Function made to remove phases that disturb the location,
% In fact it puts a weight of 4 for both P and S if exist, and recompute for
% each station

% Input:
%     mainfile
%     IN: Event structure
%     flag_plot: 1 or 0
%     
% Output:
%     OUT: Event structure with bad phases removed
%     station_reject
%     new_res


function [OUT,station_reject,new_res]=rmsta_EVENT(IN,mainfile,mstan,limit,limit_dev,flag_plot)

% sfile='loc_scratch.out';
% mainfile='mainfile_Gorkha.txt';
% flag_plot=1;

%%% Check that input is an EVENT

flag=check_EVENT(IN);
if ~flag
    fprintf(1,'input EVENT not an event structure\n');
    return
end

%%% Read mainfile

PickerParam=readmain(mainfile);
hyp=PickerParam.hyp;

%%% Initialize

station_reject=[];

%%% Read sfile

EVENT_I=IN;

%%% Extract DATA for plotting

if flag_plot
    [~,S]=extract_DATA(EVENT_I,mainfile);
    plot_DATA(S)
end

%%% Make sure that we will only consider events that where picked

A={EVENT_I.PHASES(:).ARRIVAL}';
ind_arr=cellfun(@(x) ~isempty(x),A);
PHASES_I=EVENT_I.PHASES(ind_arr);

%%% Loop and remove phases

station_list=unique({PHASES_I.STATION});
EVENT_F=init_EVENT(numel(station_list));
res=nan(numel(station_list),1);


for i=1:numel(station_list);
    station=station_list(i);
    PHASES_NEW=PHASES_I;
    [~,ind]=get_PHASE(PHASES_I,'station',station);
    for j=ind';
       PHASES_NEW(j).WEIGHT=4;
    end
    
    EVENT_F(i).PHASES=PHASES_NEW;
end


EVENT_G=hyp_EVENT(EVENT_F,hyp);

res=[EVENT_G(:).RMS];
median_res=mean(res);
ind_total=1:numel(station_list);

[output,ind]=clean_distri(res,mstan,'median',limit,limit_dev,'negative',0);
ind_sta=ind;

if isempty(ind_sta)
    new_EVENT=EVENT_I;
    new_res=median_res;
else
    new_res=res(ind_sta);
    [value,index]=min(new_res);
    if numel(index)>1
        index=index(1);
    end
    ind_sta=ind_sta(index);
    new_res=res(ind_sta);
    new_EVENT=EVENT_G(ind_sta);
    station_reject=station_list(ind_sta);
end

OUT=comp_THEO(hyp,new_EVENT);

if flag_plot
   figure
   plot(res)
   hold on
   text([1:numel(res)],res,station_list)
   hold off
end

end


