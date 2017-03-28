clear all
close all
clc

%%% Parameters

path_to_function='./Functions';
file_extension='*.m';
doc_extension='.md';
doc_dir='/media/baillard/Shared/Dropbox/_Moi/Projects/Nepal/Picking/PSPicker_release_2_0/docs';
api_list=[doc_dir,'/','api_list.md'];

%%% Check dir exist

if ~exist(doc_dir,'dir')
    mkdir(doc_dir)
end

%%% Retrieve full path to functions

F_STRUCT=dir([path_to_function,'/',file_extension]);
file_cell={F_STRUCT.name}';
fullpath_cell=cellfun(@(x)[path_to_function,'/',x], file_cell,'UniformOutput', false);

%%% Loop over functions to get the help

fic_api=fopen(api_list,'wt');

for i =1:numel(fullpath_cell)
    function_name_full=fullpath_cell{i};
    function_name=file_cell{i};
    function_name_noext=strsplit(function_name,'.');
    function_name_noext=function_name_noext{1};
    
    %%% Write into api
    
    str_api=sprintf('[%s](%s%s)  \n',function_name,function_name_noext,doc_extension);
    fprintf(fic_api,str_api);
    
    %%% Generate files
    
    doc_name_full=[doc_dir,'/',function_name_noext,doc_extension];
    
    fic_doc=fopen(doc_name_full,'wt');
    help_parag=regexprep(help(function_name_full),'\n','   \n');
    fprintf(fic_doc,help_parag);
    fclose(fic_doc);
    
end

%%% Close API list

fclose(fic_api);








