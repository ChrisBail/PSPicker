  Function made to read auto.out,collect or select.out files   
  and make a structure    
  Input: select.out or collect.out file from seisan SELECT   
  Events   
      ->date   
      ->depth   
      ->RMS   
      ->Cell->station;seconds;type;weight   
  Access event by doing:   
  B=cat(1,A(1).DATA(:).station)   
  Do read_nor() to see what the structure looks like   
