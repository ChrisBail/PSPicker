function disper=disper_kurto(kurto)

% 
% %% find mini
% 
% rsample=100;
% aa=find(~isnan(kurto(:,1)),1,'first');
% bb=find(~isnan(kurto(:,1)),1,'last');
% 
% A=loca_ext(ind-rsample,ind+rsample,kurto(:,1),'maxi');
% 
% ind_max=[aa;A(:,1);bb];
% ind_max=unique(ind_max);
% dif=ind-ind_max;
% 
% ind_left=ind_max(dif==min(dif(dif>0)));
% ind_right=ind_max(dif==max(dif(dif<0)));
% 
% %%% 
% 
% final=kurto(:,end);
% final(final>0.2*min(kurto(:,1)))=0;
% 
% B=loca_ext(ind_left,ind_right,final,'mini');
% 
% stdA=std(B(:,1));
% 
% disper=2*stdA;

%% take the two biggest

final=kurto(:,end);

A=loca_ext(1,length(final),final,'mini');

B=sortrows(A,2);
value=B(:,2);

ind_val=B(value<0.5*min(value),1);

if length(ind_val)==1
    stda=0;
else
    [~,ind_n]=max(abs(ind_val-ind_val(1)));
    ind_new=[ind_val(1) ind_val(ind_n)];
    stda=ind_new(end)-ind_new(1);
end

disper=abs(stda);

end
