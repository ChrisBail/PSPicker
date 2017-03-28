  Function made to compute the synthetics traveltimes from an Sfile, the 
  output is an Sfile containing all arrivals for all stations specified in STATION?.HYP.
  The model file needs to be in the current directory.
  Warning!!! To work:
  - matlab should be launched from a terminal so that it
  can grab the environment variables
  - the full path to the hyp program has to be given 
 
  Input:
      hyp: hyp program with full path specified
          ex: '/Users/baillard/bin/seisan_v10.3_macosx_64/PRO/hyp'
      sfile: input Sfile
          ex: '16-0046-48L.S200805'
      sfile_output: output Sfile name with all arrivals (P and S for the moment), all stations 
      specified in STATION?.HYP
          ex: 'new_16-0046-48L.S200805'
      show: if 1 shows hyp output process
