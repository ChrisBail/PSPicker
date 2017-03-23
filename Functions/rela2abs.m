% rela : n-array of picks
% t_begin: n-array beginning of the trace expressed in matlab serial number 
% rsample: sampling frequency

% NB 


function abso=rela2abs(rela,t_begin,rsample)

m=length(rela);

% conversion from number of sample to seconds

coef_datenum=24*60*60;
a=(rela./rsample)./coef_datenum;
b=datenum(a);
abso=t_begin+b;

end