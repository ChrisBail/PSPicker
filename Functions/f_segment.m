% Function to calculate the segment between first and last value of
% function. Input and output have the same size.  
% input: function (traces has to be ordered by column)
% ouput: the segment vector
%
% Input:    'f' matrix or array containing the data
%      
% Ouptut:   'segment' linear segment 

function segment=f_segment(f)

m=size(f,1);
n=size(f,2);
segment=NaN(m,n);

for i=1:n
    clear a b ya yb lin
    a=find(~isnan(f(:,i)),1,'first');    % Calculation of the straight line
    b=find(~isnan(f(:,i)),1,'last');
    ya=f(a,i);
    yb=f(b,i);
    lin=linspace(ya,yb,b-a);
    segment(:,i)=inc_nan(lin,m,a);
end
 
end
