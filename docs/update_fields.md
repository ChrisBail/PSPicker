  Developer function
  
  This function is made to update the fields of a structure, in case
  some fields were not set in prior processes, for example wyou worked with
  refine_Picks in earlier version and then afterwards you decide to define a 
  new field, instead of reprocessing the data you can just update fields to
  missing field. 
  NB: it will NOT remove fields in USER structure, just add
  
  Input:
      STRUCT_USER: user structure
      STRUCT_REF: reference structure
      
  Output:
      STRUCT_NEW: new structure with fields updated
