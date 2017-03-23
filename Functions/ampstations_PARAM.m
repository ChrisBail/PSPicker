% function made to output the list of stations to be ouputed for amplitude 
% calculation, this is a very simple function but quite useful as it can be used
% a lot of times
% 
% Input:
%     mainfile: main parameter file for PSPicker (string)
%  
% Output:
%     stations_amp: stations that will be used for amplitude calculation (cellarray)
%     
% Example:
%     stations_amp=ampstations_PARAM('mainfile_Gorkha.txt')

function stations_amp=ampstations_PARAM(mainfile)

%mainfile='mainfile_Gorkha.txt';

PickerParam=readmain(mainfile);    

stations=fieldnames(PickerParam.Station_param);
stations_amp={};

for i=1:numel(stations)
   if ~isempty(PickerParam.Station_param.(stations{i}).amp)
       stations_amp=[stations_amp;stations(i)];
   end
end

end