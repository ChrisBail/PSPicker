function [output,ind]=clean_distri(input,mstan,mode,limit_sample,limit_dev,reject_part,flag_plot)
% CLEAN_DISTRI Removes extreme values in a vector
% Usage: [output,ind]=clean_distri(input,mstan,mode,limit)

% Input:  'input'  input vector
%         'mstan'  erase values for which (x-mode(x)) > mstan*dev [default=3]
%         'mode'   'mean' or 'median' [ default = 'median' ]
%         'limit_sample'  do not clean if vector is shorter than this[default=3]
%         'limit_dev' if all abs(deviations) are below limit_dev do not clean[default=0]
%         'reject_part' You can choose to reject only samples in the
%         negative side of the gaussian or positive, or 'all'
% Output: 'output' remaining values after cleaning
%         'ind' indices of values outside distribution criterion in input vector


%           |
%      |  | |  |
%      |  | |  | |          |
%      |  | |  |?|          |
%TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT

if ~exist('mode','var');  mode='median'; end
if ~exist('mstan','var'); mstan=3; end
if ~exist('limit_sample','var'); limit_sample=3; end
if ~exist('limit_dev','var'); limit_dev=0; end
if ~exist('reject_part','var'); reject_part='all'; end
if ~exist('flag_plot','var'); flag_plot=1; end

if length(input)<limit_sample
    output=input;
    ind=[];
    return
end

%%% Compute deviation 

x=input;
if strcmp(mode,'mean')
    dev=x-mean(x);
elseif strcmp(mode,'median') 
    dev=x-median(x);
end
    
%%% Check if deviations are not too small, in that case no rejection is
%%% needed

if all(abs(dev)<limit_dev)
    output=input;
    ind=[];
    return
end

%%% Else reject
% 
% lim=round(0.68*length(x)); % assumed gaussian around median
% if lim==0
%     lim=1;
% end
% tri=sort(abs(dev));
% st=tri(lim);

st=std(dev);

%%% Choose which part to remove

if strcmp(reject_part,'negative');
    in_rm=find(dev<0 & abs(dev)>mstan*st);
elseif strcmp(reject_part,'positive');
    in_rm=find(dev>0 & abs(dev)>mstan*st);
else
    in_rm=find(abs(dev)>mstan*st);
end
v=x;
x(in_rm)=[];

ind=in_rm;
output=x;

%%% Start plot figure if asked

if flag_plot
xbins=floor(min(v)):0.5:floor(max(v)+1);
[counts,~]=hist(v,xbins);
counts_rej=hist(v(in_rm),xbins);

figure

hold on
bar_width=0.9;
b1=bar(xbins,counts,bar_width,'hist');
set(b1,'facecolor','b','edgecolor','none');
b2=bar(xbins,counts_rej,bar_width,'hist');
set(b2,'facecolor','r','edgecolor','none');
plot([median(v) median(v)],[0 max(counts)],'r');

plot([median(v)-st median(v)-st],[0 max(counts)],'k');
plot([median(v)+st median(v)+st],[0 max(counts)],'k');
plot([median(v) median(v)+st],[max(counts)/2 max(counts)/2],'k');
str_sig=sprintf('\\sigma = %.1f',st);
text((median(v)+median(v)+st)/2,max(counts)/2+0.2,str_sig)

plot([median(v)-st*mstan median(v)-st*mstan],[0 max(counts)],'g');
plot([median(v)+st*mstan median(v)+st*mstan],[0 max(counts)],'g');
plot([median(v) median(v)+st*mstan],[max(counts)/1.3 max(counts)/1.3],'k');
str_sig=sprintf('%.1f * \\sigma = %.1f',mstan,st*mstan);
text((median(v)+median(v)+st*mstan)/2,max(counts)/1.3+0.2,str_sig)
hold off

end

end