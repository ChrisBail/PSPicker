% function made to read a station file containing poles and zeros 
% the input file must be:
% 
% station channel comp gain poles zeros
% AVA : SH  Z 5 0,0,0 2,1,3
% RES : SH  Z 5 0,0,0 2,1,3
% AVA SL  Z 5 
% GKN SH  Z 0.11650840E+07 0.13180000E+02-i0.25020000E+02
%
% It's possible that gains and zeros are not defined, so just leave the last 
% columns empty
% 
% 
% Output:
%     D : structure containing Gain, Poles and Zeros
%     
%file='/Users/baillard/_Moi/Projets/Nepal/Picking/stations_PZ.txt';

function D=read_PZ(input_file)

fid = fopen(input_file,'rt');
A= textscan(fid, '%[^\n]','headerLines', 1);
fclose(fid);

D=struct;

for i=1:numel(A{1})
    
    str_array=strsplit(A{1}{i},':');
    
    station=str_array{1};
    channel=str_array{2};
    comp=str_array{3};
    gain=str2double(str_array{4});
    
    if length(str_array)==4
        poles=[];
        zeros=[];
    else
        str_poles=strsplit(str_array{5},',');
        str_zeros=strsplit(str_array{6},',');
    
        poles=cellfun(@str2double,str_poles);
        zeros=cellfun(@str2double,str_zeros); 
    end
    
    D.(station).(channel).(comp).gain=gain;
    D.(station).(channel).(comp).poles=poles;
    D.(station).(channel).(comp).zeros=zeros;
end

end