% function made to compute the amplitude given a windows around a phase
% 
% Input:
%     trace: data array
%     window: time window of size 2, matalab serial datenum
%     t_begin: time of beginning of the trace, matlab serial datenum
%     rsample: sampling rate
%     units: nothing or 'nm'
%     flag_plot; 0 or 1
%     
% Output:
%     AMP: structure containing period, max pk2pk/2 amplitude and 
%     arrival (matlab datenum)

function AMP=pick_AMP(trace,window,t_begin,rsample,units,method,flag_plot)

%%% Check method

ref_methods={'maxi' 'pk2pk'};

if ~any(strcmp(method,ref_methods))
    fprintf(1,'Given method is not valid (''maxi'' or ''pk2pk''), ''maxi'' will be used\n');
    method='maxi';
end
    
coef=1;
if strcmp(units,'nm')
   coef=10.^9; 
end

trace=trace(:);
first_sample=abs2rela(window(1),t_begin,rsample);
last_sample=abs2rela(window(2),t_begin,rsample);

if strcmp(method,'maxi')

%%% Method taking the maximum (zero-peak) on absolute

[MAX,IND]=max_window(first_sample,last_sample,abs(trace),0);
index_output=get_period(trace,IND,0);

AMP.PERIOD=diff(index_output)*2./rsample;
AMP.AMP=MAX*coef;
AMP.TIME=rela2abs(IND,t_begin,rsample);

else
    
%%% Method taking the peak to peak divided by two

Maxx=loca_ext(first_sample,last_sample,trace,'maxi');
Minn=loca_ext(first_sample,last_sample,trace,'mini');
ind=min([size(Maxx,1) size(Minn,1)]);
Maxx=Maxx(1:ind,:);
Minn=Minn(1:ind,:);
Vil=get_M(Minn,Maxx,rsample);

AMP.PERIOD=Vil(1);
AMP.AMP=Vil(2)*coef;
AMP.TIME=rela2abs(Vil(3),t_begin,rsample);

end

if flag_plot
   figure;hold on;
   ind_max=abs2rela(AMP.TIME,t_begin,rsample);
   ind_left=ind_max - (AMP.PERIOD*rsample/4);
   ind_right=ind_max + (AMP.PERIOD*rsample/4);
   
   [x_patch,y_patch]=borders2patch([first_sample last_sample],[min(trace) max(trace)]);
   patch(x_patch,y_patch,'k','facealpha',0.2,'edgecolor','none');

   plot(trace,'k');
   
   plot([ind_max ind_max],[0 trace(ind_max)],'r');
   plot([ind_left ind_right],[0 0],'r');
   
   hold off
end

end

function A=get_M(Minn,Maxx,rsample)
Diff=Maxx-Minn;
Val=Diff(abs(Diff(:,2))==max(abs(Diff(:,2))),:);
    Val=abs(Val);
    Val(:,1)=2.*Val(:,1)./rsample;
    Val(:,2)=Val(:,2)./2;
    Vat=Maxx(abs(Diff(:,2))==max(abs(Diff(:,2))),:);
    Vil=[Val Vat(:,1)];
    A=Vil;
end
    

