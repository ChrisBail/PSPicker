% rela : n-array of picks
% t_begin: n-array beginning of the trace expressed in matlab serial number 
% rsample: sampling frequency

% NB 

function rela=abs2rela(abso,t_begin,rsample)

% conversion from number of sample to samples
rela=round((abso-t_begin)*86400*rsample);

end