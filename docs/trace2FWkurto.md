  trace2FWkurto calculates cumulative kurtosis over bandwidths and windows   
    
  Usage:   
    [mean_M,C]=trace2FWkurto(f,h,FB,T,n_smooth,first,last)   
    
  The FW in the name stands for Frequency Window because it computes for   
  several frequency bandwidth and window sizes   
    
  Input:    'f' is the raw trace (works on array, not on matrix)   
            'h' is the sampling frequency   
            'FB' is an n-by-2 matrix containing n frequency band   
                    specifications   
            'T' is an m-by-1 vector of window lengths (seconds)   
            'first' is the first sample of interest   
            'last' is ,the last sample of interest   
  Ouput:    'M' is the (m*n)-by-(length(f)) kurtosis cumulative matrix   
            'sum_trace' is the mean value of the kurtosis for all windows   
            and all frequency bandwidth   
  Example:  trace2FWkurto(f,100,[5 10;15 20],[1 2 3],10,1,1500)   
