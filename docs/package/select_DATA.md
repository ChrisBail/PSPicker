  get_Trace allows this user to recover the data from a DATA structure given the station name,components   
  channel name   
     
  Inputs:   
      DATA: structure returned by get_DATA, contains all the data from an extractet events (required)   
      station: station name (required)   
      channel cell: cell containing desired channel {'SL' 'SH'} (optionnal)   
      components cell: cell containing desired channel {'Z' 'X'} (optionnal)   
         
      ex: get_TRACE(DATA,'DANN','chan','SL') returns all components associated to channel SL   
          get_TRACE(DATA,'DANN','chan','SL','comp','X') returns only X component (if exists) ass. to channel SL   
             
  Outputs:   
      comp_select: cell with comp   
      chan_select: ""   
      trace_select: cell with data   
      trace_matrix: matrix with data   
