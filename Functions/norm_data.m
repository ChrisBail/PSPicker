function out=norm_data(in)

in=in(:);
out=nan(size(in));

data=in(~isnan(in));

%%% Remove mean

data=data-mean(data);

%%% Normalize

data=data./max(abs(data));

%%% Reput in out

out(~isnan(in))=data;

end