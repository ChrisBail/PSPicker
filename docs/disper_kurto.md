  % find mini   
     
  rsample=100;   
  aa=find(~isnan(kurto(:,1)),1,'first');   
  bb=find(~isnan(kurto(:,1)),1,'last');   
     
  A=loca_ext(ind-rsample,ind+rsample,kurto(:,1),'maxi');   
     
  ind_max=[aa;A(:,1);bb];   
  ind_max=unique(ind_max);   
  dif=ind-ind_max;   
     
  ind_left=ind_max(dif==min(dif(dif>0)));   
  ind_right=ind_max(dif==max(dif(dif<0)));   
     
  %