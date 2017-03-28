  function made to compute the amplitude given a windows around a phase
  
  Input:
      trace: data array
      window: time window of size 2, matalab serial datenum
      t_begin: time of beginning of the trace, matlab serial datenum
      rsample: sampling rate
      units: nothing or 'nm'
      flag_plot; 0 or 1
      
  Output:
      AMP: structure containing period, max pk2pk/2 amplitude and 
      arrival (matlab datenum)
