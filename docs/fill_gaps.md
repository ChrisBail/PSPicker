  function to fill gaps of a time serie
  
  Inputs:
      time: time array in seconds
      data: data array (whatever you measure)
      rsample: sampling rate of the data
      value: value that fill the gaps, can be NaN
      
  Outputs:
      new_time: new time array
      new_data: filled data array
