%function made to smooth curve using a filt filt moving average
% Make that signal is 3* bifgger than signal

function out=smooth_filtfilt(in,smooth_vec)

in=in(:);
out=nan(length(in),length(smooth_vec));
data=in(~isnan(in));

%%% Avoid smoothing if smooth value is not 1/3 of window length

smooth_vec(3*smooth_vec>length(data))=[];

if isempty(smooth_vec);
    out=in;
    return
end

%%% Start smoothing

for i=1:length(smooth_vec)
    n_smooth=smooth_vec(i);
    if i==1
        fil(:,i)=filtfilt(ones(1,n_smooth)./n_smooth,1,data);
    else
        fil(:,i)=filtfilt(ones(1,n_smooth)./n_smooth,1,fil(:,i-1));
    end
    %fil(:,i+1)=filtfilt(ones(1,n_smooth)./n_smooth,1,data);
    out(~isnan(in),i)=fil(:,i);
end


end