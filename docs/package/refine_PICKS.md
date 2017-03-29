  Refine picks   
  The program takes an EVENT input (structure), reads the origin and the picks   
  extract the mseed, pick with the kurtosis and relocate the event   
     
   Input: EVENT > EVENT structure (type: struct)   
          mainfile > main configuration filename (type: str)   
          flag_plot > flag used in debug mode to plot grap (type: boolean)   
             
   Output:    S > Output EVENT containing new refined picks and new location (type: struct)   
      
   Example:   NEW_EVENT=refine_PICKS(OLD_EVENT,'mainfile.txt',0)   
      
