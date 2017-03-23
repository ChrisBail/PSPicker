% Function to filter data with a butterworth filter
% order: order of the butterworth filter
% f1 and f2: low and high cutoffs frequencies
% fech: sample rate
% trace: raw data to filter. trace can be a matrix of data with each column
% representing a trace. The filter will perform column by column


function trace_fil=filterbutter(order,f1,f2,fech,trace)

    trace_fil=nan(size(trace));

    for i=1:size(trace,2)
        trace_fil(:,i)=filterbutter_one(order,f1,f2,fech,trace(:,i));
    end

end

function tracefil=filterbutter_one(order,f1,f2,fech,trace)

    tracefil=NaN(length(trace),1);
    new=trace(~isnan(trace));
    %[b,a]=butter(order,[f1 f2]/(fech/2));
    % tracefil=filtfilt(b,a,trace);
    [b,a]=private_butter(order,[f1 f2]/(fech/2));   % WCC
    %new_f=private_filtfilt(b,a,new);
    new_f=filter(b,a,new);
    new_f(1:2*fech)=NaN;
    %tracefil(1:100)=NaN;
    tracefil(~isnan(trace))=new_f;
    
end

