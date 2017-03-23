function [first_sample,last_sample]=check_samples(first_sample,last_sample,data)

if first_sample>last_sample
    last_s=first_sample;
    first_s=last_sample;
    first_sample=first_s;
    last_sample=last_s;
end

if first_sample < 1 || first_sample>length(data)
    first_sample=1;
end

if last_sample < 1 || last_sample>length(data)
    last_sample=length(data);
end



end