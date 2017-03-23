function [out_timestart,f_out]=merge_array(timestarts,f,rsample)

    %% Compute num_traces
    
    if ~iscell(f)
        f={f};
        len_f=1;
    else
        len_f=numel(f);
    end

    %% Compute xax for each of the traces

    a=min(timestarts);
    for i=1:len_f
        xax(i)={(0:length(f{i})-1)'./(rsample)+(timestarts(i)-a)*86400};
    end

    %% Construct array

    min_ax=min(cellfun(@(x) min(x),xax));
    max_ax=max(cellfun(@(x) max(x),xax));

    dt_serial=1/(rsample);
    new_ax=(min_ax:dt_serial:max_ax)';

    f_out=NaN(length(new_ax),len_f);
    
    for i=1:len_f
        [bab,ia,ib] = intersect(round(new_ax*rsample),round(xax{i}*rsample));
        f_out(ia,i) = f{i}(ib);
    end

    out_timestart=min(timestarts);

end
