% function made to read the TEST parameters from a STATION.HYP file
% 
% Input:
%     filename: station0 filename (STATION0.HYP, must be in current directory)
% 
% Output:
%     TEST: test parameters array (see hypo71 doc in seisan for parameters info)
%     

function TEST=param_STATION0(filename)

%%% Parameters

%filename='STATION0.HYP';

%%% Check if file exist

if ~exist(filename,'file');
    error('%s doesn''t exist in current directory, abort!', filename)
end

%%% Initialize

TEST=nan(100,1);

%%% Give default values

TEST(75)=1;
TEST(76)=1.11;
TEST(77)=0.00189;
TEST(78)=-2.09;

%%% Read files

fic=fopen(filename);

while ~feof(fic)
    line=fgetl(fic);
    ind_test=regexp(line,'RESET TEST');
    if regexp(line,'RESET TEST')~=0
        ind_start=regexp(line,'TEST');
        eval_string=sprintf('%s;',line(ind_start:end));
        eval(eval_string);
    end
end

fclose(fic);


end






