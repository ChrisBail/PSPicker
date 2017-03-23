% This function is made to smooth traces sort by rows. The smooth use the
% filter function with the advantage that if the trace begins with NaN
% values it computes the smoothing without erasing the first non-nan values
% as would do the simple filter function. 
% Instead of Smooth(1)=[f(i)+f(i-1)..+f(i-n)]/(n+1) with f(i-1) and below
% NaN values we have now Smooth(i)=f(i)/1 Smooth(i+1)=[f(i+1)+f(i)]/2 ...      
% (See doc filter for more details)
% Input:    'M_in' matrix or array containing the data, column sorted
%           'n_smooth' scalar,size of the smoothing window       
% Ouptut:   'M_out' smoothed data
%       

function M_out=smooth_filter(M_in,n_smooth)

m=size(M_in,1);
n=size(M_in,2);

l=[];
for j=1:n
    a=find(~isnan(M_in(:,j)),1,'first');
    if isempty(a)
        l=[l j];
    end
end

M_in(:,l)=[];
m=size(M_in,1);
n=size(M_in,2);

M_inter=M_in;

M_inter(isnan(M_inter))=nan;
M_out=filter(ones(1,n_smooth)/n_smooth,1,M_inter);
%M_out=filtfilt(ones(1,n_smooth)/n_smooth,1,M_inter);

correction_mat=ones(m,n);   % Matrix that corrects the bias

for i=1:n
    clear ind_correc
    ind_correc=find(~isnan(M_in(:,i)),1,'first');
    if isempty(ind_correc)
        continue
    end
    correction_mat(ind_correc:ind_correc+n_smooth-1,i)=n_smooth./(1:n_smooth)';
end

M_out=M_out.*correction_mat;
M_out(isnan(M_in))=NaN;

end



    