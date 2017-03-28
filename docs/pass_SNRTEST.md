  function made to check which traces of a given DATA structure pass the 
  SNR test around a given phase 
  
  Input:
      IN: DATA structure associated to 1 station
      SNR_PARAM: structure containing all the necessary parameters (see 
      init_TESTSNR for more info).
         time_phase should be given in matlab datenum
         window, LTA, STA should be given in seconds
      flag_plot: 0 or 1
      
  Output:
      boolean_test:
      max_snr:
      SNR:
       
   Example:
      [a,b,c]=pass_SNRTEST(DATA,SNR_PARAM)
