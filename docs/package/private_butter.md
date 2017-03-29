 TSP_BUTTER Butterworth digital and analog filter design.   
    [B,A] = TSP_BUTTER(N,Wn) designs an Nth order lowpass digital   
    Butterworth filter and returns the filter coefficients in length   
    N+1 vectors B (numerator) and A (denominator). The coefficients   
    are listed in descending powers of z. The cut-off frequency   
    Wn must be 0.0 < Wn < 1.0, with 1.0 corresponding to   
    half the sample rate.   
    
    If Wn is a two-element vector, Wn = [W1 W2], BUTTER returns an   
    order 2N bandpass filter with passband  W1 < W < W2.   
    [B,A] = BUTTER(N,Wn,'high') designs a highpass filter.   
    [B,A] = BUTTER(N,Wn,'stop') is a bandstop filter if Wn = [W1 W2].   
    
    When used with three left-hand arguments, as in   
    [Z,P,K] = BUTTER(...), the zeros and poles are returned in   
    length N column vectors Z and P, and the gain in scalar K.   
    
    When used with four left-hand arguments, as in   
    [A,B,C,D] = BUTTER(...), state-space matrices are returned.   
    
    BUTTER(N,Wn,'s'), BUTTER(N,Wn,'high','s') and BUTTER(N,Wn,'stop','s')   
    design analog Butterworth filters.  In this case, Wn can be bigger   
    than 1.0.   
    
    See also BUTTORD, BESSELF, CHEBY1, CHEBY2, ELLIP, FREQZ, FILTER.   
