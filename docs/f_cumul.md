  Function that calculate the positive gradient cumulative of f
  if the gradient is positive we take the cumulative, if the gradient is
  negative then, as long as the gradient is negative, the value is the one of
  the last positive gradient. The output has then only positive gradients
       ___/
      /
  ___/
  Input:    'f' matrix or array containing the data
       
  Ouptut:   'g' cumulative output matrix 
