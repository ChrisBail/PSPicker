function Main=readmain(file)
% Function made to read the main configuration file used by PSPicker
%
% Input: file > main configuration file (type: str)
% 
% Output: Main > Structure containing all the parametesr defined in main config file (type: struct)
% 
% Example: Param=readmain('mainfile.txt')
% 

%%% Parameters

num_fields_pick=11;  % number of fields that should be given in the station line
num_fields_amp=3;

%file='/Users/baillard/_Moi/Projets/Nepal/Picking/mainfile_Gorkha.txt';

%%% Initialize

Main=struct();

%%% Read file

fic=fopen(file,'rt');
A=textscan(fic,'%[^\n]');
fclose(fic);

%%% Get the proper cells

ind_para=cellfun(@(x) ~isempty(regexpi(x,'=')),A{1});
ind_stat=cellfun(@(x) isempty(regexpi(x,'=|#')),A{1});

cell_para=A{1}(ind_para);
cell_stat=A{1}(ind_stat);

%%% Eval variables and put in struct

for i=1:length(cell_para)
    param_line_cell=strsplit(cell_para{i},'=');
    var_name=param_line_cell{1};
    var_value=param_line_cell{2};
    Main.(var_name)=eval(var_value);
end

%%% Check if paths exist

warning('off','backtrace')
if ~exist(Main.sds_path,'dir')
    warning('sds path: %s does not exist\n',Main.sds_path)
end
if ~exist(Main.hyp,'file')
    warning('hyp program: %s does not exist\n',Main.hyp)
end

%%% Eval station dependent files

Station_param=[];

%%% Initialize

X=cellfun(@(x) strsplit(x,':') , cell_stat,'UniformOutput',false);
X=cellfun(@(x) x{1},X,'UniformOutput',false);
X=unique(X);

for j=1:length(X)
    Station_param.(X{j}).pick=[];
    Station_param.(X{j}).amp=[];
end

for i=1:length(cell_stat)
    
    line=cell_stat{i};
        
    str_array=strsplit(line,':'); 
    
    %%% Check if number of fields is respected

    if length(str_array)==num_fields_pick
        
        clear SPEC
        station=str_array{1};
        type=str_array{2};
        SPEC.channelID=strsplit(str_array{3},',');
        SPEC.F_energy=eval(str_array{4});
        SPEC.Kurto_F=Main.(str_array{5});
        SPEC.Kurto_W=Main.(str_array{6});
        SPEC.Kurto_S=Main.(str_array{7});
        SPEC.Polarity_flag=eval(str_array{8});
        SPEC.Lag=eval(str_array{9});
        SPEC.Energy_recond=eval(str_array{10});
        SPEC.N_follow=eval(str_array{11});

        Station_param.(station).pick.(type)=SPEC;
        
    elseif length(str_array)==num_fields_amp
        
        clear SPEC
        station=str_array{1};
        type=str_array{2};
        SPEC.channelID=strsplit(str_array{3},',');

        Station_param.(station).amp.(type)=SPEC;
        
    else
        fprintf(1,'Check line %i\n',i);
        continue
    end
    
end

%%% Fill struct

Main.Station_param=Station_param;

end


