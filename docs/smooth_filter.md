  This function is made to smooth traces sort by rows. The smooth use the
  filter function with the advantage that if the trace begins with NaN
  values it computes the smoothing without erasing the first non-nan values
  as would do the simple filter function. 
  Instead of Smooth(1)=[f(i)+f(i-1)..+f(i-n)]/(n+1) with f(i-1) and below
  NaN values we have now Smooth(i)=f(i)/1 Smooth(i+1)=[f(i+1)+f(i)]/2 ...      
  (See doc filter for more details)
  Input:    'M_in' matrix or array containing the data, column sorted
            'n_smooth' scalar,size of the smoothing window       
  Ouptut:   'M_out' smoothed data
        
