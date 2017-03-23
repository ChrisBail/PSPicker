function prcdata = rm_instrum_resp(rawdata,badvals,samplrate,pols,zers,...
    flo,fhi,ordl,ordh,digout,digoutf,ovrsampl,idelay)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% rm_instrum_resp: remove instrument response given poles and zeros with a
% causal inverse filter
%
% Last update 4/22/2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input arguments
%
% rawdata:      vector of raw uncorrected data in digital counts
% badvals:      value of data during telemetry drop or clip (e.g., -2^31)
% samplrate:    the sampling rate (Hz)
% pols:         poles (radians/sec, not Hz)
% zers:         zeros (radians/sec, not Hz)
% flo and fhi:  frequency range over which to get instrument response (Hz)
% ordl          Butterworth order at flo, the low cutoff (between 2 and 4)
% ordh          Butterworth order at fhi, the high cutoff (between 3 and 7)
% digout:       inverse gain (m/s/count)
% digoutf:      frequency of normalization (Hz)
% ovrsampl:     over-sampling factor for digital filter accuracy (e.g., 5)
% idelay:       intrinsic delay in the acquisition system
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% NOTES: 
% 
% 1. A hanning taper is applied to both the start and end of the
% raw seismogram prior to instrument correction. The length of the taper is 
% specified at line 93. It is the smaller of the following two values: 10
% percent of the entire length of the data or the longest period (1/flo) 
% desired.
%
% 2. The time window of the data (the recording length) must be at least 
% five times the longest period desired. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

in=rawdata;
clear rawdata
rawdata=in(~isnan(in));
out=nan(size(in));

%%%% Remove mean and detrend

% Let's remove mean
rawdata=rawdata-mean(rawdata);

% Let's remove linear trend
%rawdata=detrend(rawdata);

% check for bad data values, if these exist the user is prompted to 
% do something about them and try again
if (sum(rawdata == badvals) ~= 0)
    error('Bad data values exist in the data, clean them up and try again')
else
end

% check that the frequency band is wide enough
% the frequency interval of the data
dfo = samplrate/length(rawdata);
if ( fhi < (flo+(10*dfo)) )  
    error('Frequency band not wide enough, increase fhi or decrease flo')
else
end

% check that the recording length is at least 5 times the longest period 
if ( length(rawdata)*(1/samplrate) < (5/flo) )
    error('Lowest frequency too low, increase flo or time window used')
else
end

% check that the orders of the Butterworth filters are acceptable
if ( ordh > 7 || ordh < 3 || ordl > 4 || ordl < 2 )
    error('Need lowpass orders from 2 to 4 and hipass orders from 3 to 7')
else
end

% see if the input vector is a row or a column
% if it is a column, change it to a row, do everything, 
% then change it back to a column at the end for output
rn = size(rawdata);
isflp = 0; % a flag which says if vector was flipped
if (rn(2) == 1)
    rawdata = rawdata';
    isflp = 1;
else
end

% nearest neighbor interpolate
rawdata = interp1([1:ovrsampl:(ovrsampl*length(rawdata))],...
    rawdata,[1:(ovrsampl*length(rawdata))],'nearest','extrap');

% get the sample time interval for the oversampled data
dt = 1/(ovrsampl*samplrate);

% get the nyquist frequency
fnyq = 1/(2*dt);

% make a hanning taper and pad the data with zeros equal to data length

% taper at most 10% of window at beginning and end
flo = max([(1/(.1*length(rawdata)*dt)) flo]);
% length of taper
tlen = round(0.5/(flo*dt))*2; % guarantees an even number
tpr = [0 ; hanning(tlen-2); 0]';
% the taper for the entire seismogram
tpr2 = [tpr(1:(tlen/2)) ones(1,(length(rawdata)-tlen)) ...
    tpr(((tlen/2)+1):tlen)];
% pad the data
tpr3 = [ tpr2 zeros(1,length(rawdata)) ];
% taper the raw data
rawdata = [ rawdata zeros(1,length(rawdata)) ].*tpr3;

% get the length of the oversampled and tapered data
len = length(rawdata);

     
% apply the bilinear transform

% compute digital zeros and multiplicative factor used in digital response
zersdp = 1;
for ii=1:length(zers)
    zersd(ii) = ((2/dt)+zers(ii))/((2/dt)-zers(ii));
    zersdp = zersdp*(((2/dt)-zers(ii)));
end

% compute digital poles and multiplicative factor used in digital response
polsdp = 1;
for ii=1:length(pols)
    polsd(ii) = ((2/dt)+pols(ii))/((2/dt)-pols(ii));
    polsdp = polsdp*(((2/dt)-pols(ii)));
end

% compute additional poles or zeros
if (length(pols) > length(zers))

    for ii=(length(zers)+1):length(pols)
        zersd(ii) = -1;
    end

elseif (length(pols) < length(zers))
    
    for ii=(length(pols)+1):length(zers)
        polsd(ii) = -1;
    end

else
    % same number of poles and zeros, so no additional
end


% some shorthand variables for lengths
len2=len/2;
len2p1=len2+1;

% make the non-negative frequencies, including nyquist
ws = 2*pi*[0:(len2)]*(1/(len2))*(1/(2*dt));

% the normalizing factor 
nfactr = 1/abs(polyval(poly(zers),2*pi*digoutf*i)/polyval(poly(pols),...
    2*pi*digoutf*i));

% butterworth filters to limit frequency band
[bf af] = butter(ordh,(fhi/fnyq));
[bbf aaf] = butter(ordl,(flo/fnyq),'high');

% butterworth responses
hl1 = freqz(bf,af,len2p1); 
hh1 = freqz(bbf,aaf,len2p1);

% get filter impulse responses to check if butterworth filters are stable
ytl = filter(bf,af,[1 zeros(1,len-1)]);
yth = filter(bbf,aaf,[1 zeros(1,len-1)]);
% get the locations of the maximum envelope of the impulse responses
[mxal mxll] = max(abs(hilbert(ytl)));         
[mxah mxlh] = max(abs(hilbert(yth)));

% check if low pass butterworth filter is stable
if (sum(isnan(ytl)) > 0 || (mxll/len) > 0.9 )
    error('Low pass Butterworth filter is unstable, decrease ordh')
else
end
% check if high pass butterworth filter is stable
if (sum(isnan(yth)) > 0 || (mxlh/len) > 0.9 )
    error('High pass Butterworth filter is unstable, decrease ordl')
else
end

% the inverse digital filter
respd_inv = digout*freqz((polsdp/(nfactr*zersdp))*poly([polsd]),...
    poly([zersd]),len2p1);
respd_inv = respd_inv.*hl1.*hh1;
respd_inv = transpose(respd_inv);
% set the zero frequency to zero
respd_inv(1) = 0;
% make it real
respd_inv_full = [conj(respd_inv(end:-1:2)) respd_inv(1:(end-1))];
% make it causal
respd_inv_full = real(respd_inv_full) - ...
    i*imag(hilbert(real(respd_inv_full)));

% deconvolve by spectral division
d1nf = real(ifft(ifftshift(fftshift(fft(rawdata)).*(respd_inv_full))));

% unpad
prcdata = d1nf(1:(len/2));

% apply the instrinsic delay
% if the instrinsic delay is not a multiple of the sample rate, round up
na = ceil((idelay*.001)/dt);
prcdata = [prcdata((na+1):end) prcdata(1:na)];

% find out which toolboxes are available
vr = ver;
% collect the names in a cell array
[installedToolboxes{1:length(vr)}] = deal(vr.Name);

% do toolboxes exist to account for fractional part of intrinsic delay?
% for R2010a
requiredToolboxes = 'Filter Design Toolbox';
tf1 = all(ismember(requiredToolboxes,installedToolboxes));
% for R2011a
requiredToolboxes = 'DSP System Toolbox';
tf2 = all(ismember(requiredToolboxes,installedToolboxes));

% if toolboxes are available, apply the fractional part of the delay
if (tf1 == 1 | tf2 == 1)
    Hd = dfilt.farrowlinearfd(rem((idelay*.001),dt)/dt);
    prcdata = filter(Hd,prcdata);
    prcdata = prcdata.*tpr2;
else
    % do not account for fractional delay if toolboxes aren't available
end

% decimate
prcdata = prcdata(1:ovrsampl:end);

% if we were originally handed a column vector, flip to give column back
if (isflp == 1)
    prcdata = prcdata';
else
end

out(~isnan(in))=prcdata;
clear prcdata;
prcdata=out;

end









