% Transform cumulative into function that is shift at 0 for all maxima

function f_out=cum2grad(f_in,option)

if isempty(f_in); error('f_in is empty!'); end

tycalpha=zeros(size(f_in));
%tycgamma=zeros(length(f_in),1);
tikx=loca_ext(1,length(f_in),f_in,'maxi');
tikx=tikx(:,1);
clear a b
a=find(isnan(f_in)==0,1,'first');
b=find(isnan(f_in)==0,1,'last');
if isempty(tikx)
    tikx=[a;b];
else
    tikx=[a;tikx;b];
end

tiky=f_in(tikx);

for j=length(tikx)-1:-1:1
     tycalpha(tikx(j):tikx(j+1))=tiky(j+1);
end

f_out=f_in-tycalpha;
f_out(f_out>0)=0;
if strcmp(option,'normalize')
    f_out=f_out./abs(min(f_out));
end
end
