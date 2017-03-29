  Function made to retrieve and track the minimum of each kurtosis characteristic function   
  The function looks first for the global minimum on the kurtosis CF obtained with the larger window.   
  Therefore it's really important that the CF in data are sorted from the larger kurtosis window to the smaller    
  kurtosis window. Once it has picked the global minimum, it tracks the minimum on the the more sensitive CF.   
  The maximum drift allowed for looking to the left side of the global minimum is specfied   
  by swin_drift.    
     
  Input:  CF > Array containing sorted kurtosis CF in each column, from the larger window to the smaller window   
                  this Array is given by trace2FWkurto (type: array)   
          swin_drift > window size in sample to allow drift of the minimum (usually 10 samples is enough) (type:integer)   
             
  Output: ind_pick > final pick index (type:int)   
          vals_kurto > value of the max amplitude of the kurtosis for each CF (useful for weighting of the pick)   
             
  Example:    [ind_pick,vals_kurto]=follow_extrem2(CF_matrix,10)    
