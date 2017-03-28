 STRSPLIT Splits a string into multiple terms   
    
    terms = strsplit(s)   
        splits the string s into multiple terms that are separated by   
        white spaces (white spaces also include tab and newline).   
    
        The extracted terms are returned in form of a cell array of   
        strings.   
    
    terms = strsplit(s, delimiter)   
        splits the string s into multiple terms that are separated by   
        the specified delimiter.    
       
    Remarks   
    -------   
        - Note that the spaces surrounding the delimiter are considered   
          part of the delimiter, and thus removed from the extracted   
          terms.   
    
        - If there are two consecutive non-whitespace delimiters, it is   
          regarded that there is an empty-string term between them.            
    
    Examples   
    --------   
        