 STRJOIN Concatenate an array into a single string.
 
      S = strjoin(C)
      S = strjoin(C, separator)
 
  Description
 
  S = strjoin(C) takes an array C and returns a string S which concatenates
  array elements with comma. C can be a cell array of strings, a character
  array, a numeric array, or a logical array. If C is a matrix, it is first
  flattened to get an array and concateneted. S = strjoin(C, separator) also
  specifies separator for string concatenation. The default separator is comma.
 
  Examples
 
      >> str = strjoin({'this','is','a','cell','array'})
      str =
      this,is,a,cell,array
 
      >> str = strjoin([1,2,2],'_')
      str =
      1_2_2
 
      >> str = strjoin({1,2,2,'string'},'	')
      str =
      1 2 2 string
 
