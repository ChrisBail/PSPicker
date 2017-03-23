% function that extract part of an initial vector and return a new vector
% which has the same size than the old one filled with NaNs

function mat_new=same_inc(mat_old,left,right)

%%% Make sure that indices are rounded

left=round(left);
right=round(right);

m=size(mat_old,1);
n=size(mat_old,2);

if left<1;
    left=1;
end

if isempty(mat_old)
    %sprintf('vector %s is empty',mat_old);
    mat_new=[];
end

len=size(mat_old,1);
% Change shape of the vector if it's not in column

%formula

try
    mat_new=cat(1,NaN(left-1,n),mat_old(left:right,:),NaN(len-right,n));
catch
    try
        mat_new=cat(1,NaN(left-1,n),mat_old(left:len,:));
    catch
        mat_new=cat(1,mat_old(1:right,:),NaN(len-right,n));
    end
end
    

end

