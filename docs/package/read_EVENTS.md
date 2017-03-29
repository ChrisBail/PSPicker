  Function that reads the event file output by Andreas'Rietbrock binder   
  it stores all the info in a structure   
  Just type the function with no arguments to get the structure hierarchy   
  Input:   
      event_file: fullpath to event file   
     
  Output:   
      EVENT: structure   
         
  Example:   
    A=read_EVENTS() will return an empty EVENT structure (equivalent to   
    init_EVENT(1)   
    
    A=read_EVENTS('events.txt','e','test.mat') will read the events.txt file    
    and save it into test.mat if this file doesn't already exists.   
