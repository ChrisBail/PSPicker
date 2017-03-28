  Function made to ouptut the cleaned PHASES and the new mag based    
  on removal of bad magnitude. Bad magnitudes are removed if they are outside    
  n*sigma where n is an input.   
  Amplitudes and magnitudes are not removed for bad phases they are just set   
  with a 0 flag (see PHASES.WRITE_FLAG) so that we know that this magnitude will    
  not be used in the written output (event2nor), write-flag only concerns   
  amplitudes writing, not picks   
     
  Input:   
     PHASES: input PHASES that has to be cleaned   
     n: into n*sigma (usually in that cases for magnitude we will take 1 or 2)   
     
  Output:   
      OUT_PHASES: cleaned phases   
      new_mag: new magnitude computed after removal   
