% function made to compute seconds to hours, minutes and seconds
% Input :
%     total : total number of seconds
% Output :
%     nhours
%     nmins
%     nsecs

function [nhours,nmins,nsecs]=seconds2hms(total)

%total=hours*3600+minutes*60+seconds;

nhours=floor(total/3600);
nmins=floor((total-3600*nhours)/60);
nsecs = total - 3600*nhours - 60*nmins;

end