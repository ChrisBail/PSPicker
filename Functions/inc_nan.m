%%%%%
% function to include a vector in a bigger NaN vector
% input: length of NaN vector (1 dim) "n", first sample to include the vector "i",
% the vector itself "small_v"
% ouput: vector which has the same size as NaN "big_v"

function big_v=inc_nan(small_v,n,i)

if size(small_v,1)==1
    small_v=small_v';
end

if length(small_v)>n
    return;
else
    b=length(small_v);
    big_v=cat(1,NaN(i-1,1),small_v,NaN(n-(b+i)+1,1));
end

end

