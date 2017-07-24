% Function made to compute the synthetics traveltimes from an Sfile, the 
% output is an Sfile containing all arrivals for all stations specified in STATION?.HYP.
% The model file needs to be in the current directory.
% Warning!!! To work:
% - matlab should be launched from a terminal so that it
% can grab the environment variables
% - the full path to the hyp program has to be given 
%
% Input:
%     hyp: hyp program with full path specified
%         ex: '/Users/baillard/bin/seisan_v10.3_macosx_64/PRO/hyp'
%     sfile: input Sfile
%         ex: '16-0046-48L.S200805'
%     sfile_output: output Sfile name with all arrivals (P and S for the moment), all stations 
%     specified in STATION?.HYP
%         ex: 'new_16-0046-48L.S200805'
%     show: if 1 shows hyp output process

function comp_ARRIVALS(hyp,sfile,sfile_output,show)

%% Locate and generate synthetics

% hyp='/Users/baillard/bin/seisan_v10.3_macosx_64/PRO/hyp';  % Path to hyp program
% sfile='16-0046-48L.S200805';
% sfile_output=['new',sfile];

S=read_nor(sfile);


%% Checking Files and Programs
%%% Check if file and hyp location exist

if exist(hyp,'file')~=2;
    error('Program for location:\n%s\ndoes''t exist. Remember to give full path to hyp program.',hyp);
end

if exist(sfile,'file')~=2;
    error('Sfile:\n%s\ndoes''t exist.',sfile);
end

%%% Check which STATION.HYP should be used and check if exists in current
%%% directory

modelindic=S.modelindic;
if strcmp(modelindic,' ')
    mod_name='0';
else
    mod_name=modelindic;
end

model_file=['STATION',mod_name,'.HYP'];

if isempty(dir(fullfile('../',model_file)))
    error('No %s file in current directory, impossible to invert.',model_file);
else
    copyfile(['../',model_file],['./',model_file])
    station_list=read_STATION0HYP(model_file);
    station_list={station_list{:,1}}';
end


%% Start Location Process
%%% Start 1st location

cmd=sprintf('%s %s',hyp,sfile);
if show
    system(cmd);
else
    [x,y]=system(cmd);
end

%%% Read hyp.out 

H=read_nor('hyp.out');

cmd=sprintf('cp -f %s %s','hyp.out','first_loc.out');
system(cmd);


%%% Define synthetic and fix location

N=H;

N.fixdepth='F';
N.fixepic='F';
N.fixtime='F';

%%% Define time for P and S for all stations

%%% Get fresh DATA structure

Scratch=read_nor();
DATA=Scratch.DATA;

k=1;
for i=1:length(station_list)
    for j={'P','S'}
        DATA(k).station=station_list{i};
        DATA(k).phase=j{1};
        DATA(k).hour=H.hour;
        DATA(k).min=H.min;
        DATA(k).sec=H.sec; 
        k=k+1;
    end    
end

N.DATA=DATA;

write_nor(N,'scratch.dat');

%%% Locate 2nd time to get residuals

cmd=sprintf('%s %s',hyp,'scratch.dat');
if show
    system(cmd);
else
    [x,y]=system(cmd);
end

%%% Apply residuals to get final arrival time

cmd='sed -n ''/stn  /,/^$/p'' print.out | tail -n+2 | awk ''{print substr($0,1,5),substr($0,26,2),substr($0,42,2),substr($0,44,2),substr($0,47,4),substr($0,58,6)}'' > travel.out';
system(cmd);

fic=fopen('travel.out','rt');
A=textscan(fic,'%s %s %f %f %f %f\n') ;
fclose(fic);

stations=A{1};
types=A{2};
hour=A{3};
min=A{4};
sec=A{5};
res=A{6};

H=read_nor('hyp.out');
scr=read_nor();
H.DATA=scr.DATA;

for i=1:numel(stations)
    
    %%% compute total number of seconds
    
    total=hour(i)*3600 + min(i)*60 + sec(i) + res(i);
    [nhours,nmins,nsecs]=seconds2hms(total);
    H.DATA(i).hour=nhours;
    H.DATA(i).min=nmins;
    H.DATA(i).sec=nsecs; 
    H.DATA(i).station=stations{i};
    H.DATA(i).phase=types{i};
end

%% Locate and Move files

write_nor(H,'scratch.dat');

%%% Locate to get residuals

cmd=sprintf('%s %s',hyp,'scratch.dat');
if show
    system(cmd);
else
    [x,y]=system(cmd);
end

cmd=sprintf('mv -f %s %s','hyp.out',sfile_output);
system(cmd);


end













