  Function made to compute the amplitude associated to picks.   
  The function requires a location and theoretical arrival times because we pick   
  the amplitudes on theoretical arrivals.   
  The input of the function is an EVENT structure   
  First the function will convert velocities to displacements (Poles and zeros file needed)   
  then we'll take windows around arrivals to get the amplitude, several amplitudes for a same   
  station and channel can be computed, an amplitude is necessarly linked a phase (P,S, Pn..) to form a pair   
  The Output is an event structure   
