  function made to compute the maximum gradient of the histogram to detect 
  strange variation of samples distribution. The maximum gradient is normalized
  by an extremum gradient where all samples are zeros, thus the gradient
  is 1 / delta(x), we normalized the trace before processing to ensure the min, max 
  of the trace is -1/+1. delta_x should not be changed and is equal to 0.01 (200 steps
  from -1 to 1).
  
  Input:
      trace: trace to be processed
      first_sample, last_samples: samples windowing the trace to be processed
      flag_plot: 0 or 1, of you want to plot
      
  Output:
      max_gradient: maximum gradient of the histogram
      
  Example:
      max_gradient=maxgrad_histo(trace,1,numel(trace),1)
