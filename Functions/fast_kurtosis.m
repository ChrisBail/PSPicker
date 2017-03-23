% function to compute kurtosis really quickly by using "filter" function
% Input:    'inp' matrix or array containing the trace
%           'window_sample' number of sample in the sliding window      
% Ouptut:   'out' Kurtosis of the trace
%       


function [out,A]=fast_kurtosis(inp,window_sample)

if window_sample==1 % Function doesn't work with window sample <1
    window_sample=2;
end

% Taking care of NaNs

f=inp;
inp=inp-mean(inp(~isnan(inp)),1);
inp(isnan(inp)==1)=0;

% Variables

Nwin=window_sample;

% Compute kurtosis

% A=filter(ones(Nwin,1)/Nwin,1,inp);
% f1=A;
% f2=filter(ones(Nwin,1)/Nwin,1,inp.^2);
% f3=filter(ones(Nwin,1)/Nwin,1,inp.^3);
% f4=filter(ones(Nwin,1)/Nwin,1,inp.^4);
% m_2=f2-A.^2;
% m_4=f4-4.*A.*f3+6.*(A.^2).*f2-4.*f1.*A.^3+A.^4;
m_2=filter(ones(Nwin,1)/Nwin,1,inp.^2);
m_4=filter(ones(Nwin,1)/Nwin,1,inp.^4);

out=m_4./(m_2.^2);

out(isnan(f)==1)=NaN;
for i=1:size(inp,2)
    a=find(~isnan(f(:,i)),1,'first');
    out(a:a+Nwin-2,i)=NaN;
end


end

