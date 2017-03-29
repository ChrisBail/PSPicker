  This function is made to initialize PHASE structure, which is the main Structure   
  to store phases info (amplutide, picks, SNR...)   
  WRITE_FLAG parameter is used to decide or not if the phase has   
  to be taken into account before writing it in a nordic file for example, at   
  the beginning it set to 1 because we consider all phases are valid (a priori)   
     
  Input:   
      len_phases : size of the info structure   
     
  Output:   
      PHASE : Phase structure of length len_phase   
