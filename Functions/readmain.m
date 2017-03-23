%%% New version of readmain 

function Main=readmain(file)

%%% Parameters

num_fields_pick=11;
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

%%% Eval variables

for i=1:length(cell_para)
    evalc(cell_para{i});
end

%%% Check if paths exist

if ~exist(sds_path,'dir')
    error('sds path: %s does not exist\n',sds_path)
end
if ~exist(hyp,'file')
    error('hyp program: %s does not exist\n',sds_path)
end

%%% Put in structure

Main.input_nordic=input_nordic;
Main.SDS_path=sds_path;
Main.HYP=hyp;
Main.sfile_folder=sfile_folder;
Main.Extract_time=extract_time;
Main.R_freq=R_freq;
Main.SNR_wind=SNR_wind;
Main.SNR_quality=SNR_quality;
Main.SNR_thres=SNR_thres;
Main.Amplitude_remove=Amplitude_remove;
Main.window_P=window_P;
Main.window_S=window_S;
Main.window_max_S=window_max_S;
Main.picking_method=picking_method;
Main.minphase_amp=minphase_amp;

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
        SPEC.Kurto_F=eval(str_array{5});
        SPEC.Kurto_W=eval(str_array{6});
        SPEC.Kurto_S=eval(str_array{7});
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

% function OUT=get_line(IN,line,format_line)
% 
%     clear SPEC
%     
%     %%% Split characters
%     
%     str_array=strsplit(line,':'); 
%     
%     switch format_line
%         case 'pick'
%             
%             %%% Get parameters
%     
%             station=str_array{1};
%             type=str_array{2};
%             SPEC.channelID=strsplit(str_array{3},',');
%             SPEC.F_energy=eval(str_array{4});
%             SPEC.Kurto_F=eval(str_array{5});
%             SPEC.Kurto_W=eval(str_array{6});
%             SPEC.Kurto_S=eval(str_array{7});
%             SPEC.Polarity_flag=eval(str_array{8});
%             SPEC.Lag=eval(str_array{9});
%             SPEC.Energy_recond=eval(str_array{10});
%             SPEC.N_follow=eval(str_array{11});
%             SPEC.Amplitude=eval(str_array{12});
%             
%             IN.(station).pick.(type)=SPEC;
%             
%         case 'amp'
%             
%             %%% Get parameters
%     
%             station=str_array{1};
%             type=str_array{2};
%             SPEC.channelID=strsplit(str_array{3},',');
% 
%             IN.(station).amp.(type)=SPEC;
%             
%     end
% 
%     OUT=IN;
%     
% end



