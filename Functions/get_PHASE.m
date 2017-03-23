%%% function to extract specific phase structure from a phase structure
%
% Input:
%     IN: Input phase strucrure
%     varargin: station, channel or type to select the criterion
%     
% Output:
%     OUT: Output phase structure
%     ind: Indices of phases extracted
%     
% Example:
%     [OUT,ind]=get_PHASE(PHASE,'station','GKN')
    

function [OUT,ind]=get_PHASE(IN,varargin)

   p = inputParser;
   default_char='999';
    
   check_var=@(x) ischar(x) | iscell(x);
   addRequired(p,'IN',@isstruct);
   addParamValue(p,'station',default_char,check_var);
   addParamValue(p,'chan',default_char,check_var);
   addParamValue(p,'type',default_char,check_var);

   parse(p,IN,varargin{:});
   
   IN=p.Results.IN;
   station=p.Results.station;
   chan=p.Results.chan;
   type=p.Results.type;
   
   all_chan={IN(:).CHAN}';
   all_station={IN(:).STATION}';
   all_type={IN(:).TYPE}';
   
      all_chan=inc_nan(all_chan);
      all_station=inc_nan(all_station);
      all_type=inc_nan(all_type);

   if strcmp(chan,default_char);
       chan=all_chan;
   end
   if strcmp(station,default_char);
       station=all_station;
   end
   if strcmp(type,default_char);
       type=all_type;
   end
       
  cmd=ismember(all_station,station) & ...
  ismember(all_chan,chan) & ...
  ismember(all_type,type);


  ind=find(cmd==1);
  OUT=IN(ind); 
   
end

function out=inc_nan(in)

out=in;
out(cellfun(@isempty,in),1)={'NaN'};

end