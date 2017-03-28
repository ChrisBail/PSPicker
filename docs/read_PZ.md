  function made to read a station file containing poles and zeros 
  the input file must be:
  
  station channel comp gain poles zeros
  AVA : SH  Z 5 0,0,0 2,1,3
  RES : SH  Z 5 0,0,0 2,1,3
  AVA SL  Z 5 
  GKN SH  Z 0.11650840E+07 0.13180000E+02-i0.25020000E+02
 
  It's possible that gains and zeros are not defined, so just leave the last 
  columns empty
  
  
  Output:
      D : structure containing Gain, Poles and Zeros
      
 file='/Users/baillard/_Moi/Projets/Nepal/Picking/stations_PZ.txt';
