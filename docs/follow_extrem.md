  FOLLOW_EXTREM find extremas using several smoothed versions of a function
 
  Steps:
    1) locate the 'n' first extremas of the smoothest function
    2) refine these points step by step through less and less smooth functions
 
  Usage:
    M,ind_ext,ext2]=follow_extrem(f,type,num,smooth_vec,option,sense)
 
  Inputs:
    f, array of interest (unsmoothed)
    type:  'mini' or 'maxi', depending on wheter you want to follow minima
            or maxima
 	num:    number of extrema to follow
 	smooth_vec: vector containing the different smoothings to apply
    option: 'normalize': normalize (what?)
            anything else: don't normalize
 	sense:	'first': selects the 'num' first extrema, starting from the right
            anything else: select the 'num' biggest extrema
  Outputs:  value_ext, extrema of unsmoothed function
            ind_ext, indices of extrema
  Exemple:  [value_ext,ind_ext]=follow_extrema(f,'mini',2,[1 5 10]
