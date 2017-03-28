  function made to compute the histo of the a slinding kurtosis to detect bad
  signals, a lot has still to be done on that, big potential. This function
  should be use on trace big enough to be statistically realistic
  
  Input:
      trace: trace to be processed
      first_sample & last_sample: window to be processed
      kurto_sample : window size counted in samples to process the kurtosis
      pivot_value : value from which to compute the standard value (usually 1.5)
      
  Output:
      ratio_low:  ratio of samples under the pivot_value / total number of samples
      std_value: 68 