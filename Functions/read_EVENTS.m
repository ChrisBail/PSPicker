% Function that reads the event file output by Andreas'Rietbrock binder
% it stores all the info in a structure
% Just type the function with no arguments to get the structure hierarchy
% Input:
%     event_file: fullpath to event file
% 
% Output:
%     EVENT: structure
%     
% Example:
%   A=read_EVENTS() will return an empty EVENT structure (equivalent to
%   init_EVENT(1)
%
%   A=read_EVENTS('events.txt','e','test.mat') will read the events.txt file 
%   and save it into test.mat if this file doesn't already exists.

function EVENT=read_EVENTS(varargin)

%%% Do not read the file if the .dat is already in the directory
%%% Check arguments given

flag_save=0;

if length(varargin)==3
    flag_save=1;
    type_file=varargin{2};
    save_file=varargin{3};
end

if length(varargin)==2
    type_file=varargin{2};
end

if isempty(varargin)
    %%% Just output an empty EVENT structure
    EVENT=init_EVENT(1);
    return
else
    file=varargin{1};
end

%%% Check if file already exist (if yes, open it and skip the reading part)

if flag_save && exist(save_file,'file')~=0    % File already exist
    
        EVENT=load(save_file);
        
        %%% Check how many variables are stored, if more than one then
        %%% return
        
        fields_variables=fieldnames(EVENT);
        num_variables=numel(fields_variables);
        if num_variables~=1
            fprintf(1,'Loaded file : %s contains more than one variable\n',save_file);
            return
        end
        
        EVENT=EVENT.(fields_variables{1});
        
        %%% Check than the given variable is a proper EVENT 
        %%% Otherwise return
        
        flag_event=check_EVENT(EVENT);
        
        if ~flag_event
            return
        end
end
        
%%% Initialize structure

len_events=10000;

EVENT=init_EVENT(len_events);

%%% Read file

fic=fopen(file,'rt');

k=0;

%%% Check what type of file it is, MSPicker events or picks file

if strcmp(type_file,'e')
    A=textscan(fic,'%s','delimiter','\n','collectoutput',1);

    %%% Fill the strcuture with info

    lines=A{1};  
    for i=1:length(lines)
        line=lines{i};
        split_cell=strsplit(line,' ');
        
        %%% Stop process if string 'No events found' is found
        if strcmp(line,'No events found')
            break
        end        
        if numel(split_cell)==13
            if k~=0
                %%% Remove duplicate
                EVENT(k).PHASES=rmduplicates_PHASE(EVENT(k).PHASES);
            end
                
            k=k+1;
            EVENT(k).PHASES=rmempty_PHASE(EVENT(k).PHASES);
        end        
        EVENT(k)=feed_EVENT(lines{i},EVENT(k));
        if i==length(lines)
            EVENT(k).PHASES=rmduplicates_PHASE(EVENT(k).PHASES);
        end
    end
    
elseif strcmp(type_file,'p')
    k=k+1;
    A=textscan(fic,'%f %s %*s %s %*[^\n]');
    arrivals=unix2matlab(A{1});
    stations=A{2};
    types=A{3};
    len_phases=numel(stations);
    
    %%% Store into phases structure
    
    for j=1:length(stations)
        EVENT(k).PHASES(j).STATION=stations{j};
        EVENT(k).PHASES(j).TYPE=types{j};
        EVENT(k).PHASES(j).ARRIVAL=arrivals(j);
    end
    
else
    fprintf(1,'Wrong type chosen, "p" or "e"');
end

%%% Remove empty events and close file

EVENT(k+1:len_events)=[];
fclose(fic);

%%% Save variable if asked

if flag_save
   save(save_file,'EVENT'); 
end

end

%%% feed the EVENT structure properly

function EV=feed_EVENT(line,EV)
    split_cell=textscan(line,'%s','delimiter',' ');
    split_cell=split_cell{1};
    if length(split_cell)==13

        scratch=textscan(line,'%f %*f %*f %*f %*f %*f %*f %f %f %f %*[^\n]');
        EV.ORIGIN=unix2matlab(scratch{1});
        EV.LAT=scratch{2};
        EV.LON=scratch{3};
        EV.DEP=scratch{4};
        EV.ID=datestr(EV.ORIGIN,'yyyy-mm-dd HH:MM:SS');
    else
        
        %%% Initialize new phases structure
        
        NEW_PHASES=init_PHASE(1);
        
        %%% Get number of phases already stored
        scratch=textscan(line,'%s %f %f %*f %*f %s %*[^\n]');
        station=regexprep(scratch{1},'_','');
        station=station{1};
        NEW_PHASES.STATION=station;
        NEW_PHASES.ARRIVAL=unix2matlab(scratch{2});
        NEW_PHASES.TYPE=scratch{4}{1};
        NEW_PHASES.RMS=scratch{3};
        
        EV.PHASES(length(EV.PHASES)+1)=NEW_PHASES;
        
    end
end





