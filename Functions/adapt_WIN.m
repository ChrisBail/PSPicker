% function made to adapt window size, so that there is no overlap of windows
% when searching for amplitudes for each phase
%
% Input:
%     IN: PHASES structure
%     station: List of stations or one station
%     
% Output:
%     OUT: PHASES structure with windows adapted
%
% Example: OUT=adapt_WIN(PHASES,'station',
    
function OUT=adapt_WIN(IN,varargin)

%%% Parse results

p = inputParser;

check_var=@(x) ischar(x) | iscell(x);
addRequired(p,'IN',@isstruct);
addParamValue(p,'station',0,check_var);
addParamValue(p,'coef',0,@isscalar);

parse(p,IN,varargin{:});

stations=p.Results.station;
coef=p.Results.coef;

%%% Check if given structure is a phase structure

if ~check_PHASE(IN)
    return
end

PHASES=IN;

%%% 

if stations==0
    stations={PHASES(:).STATION}';
end

if ~iscell(stations)
    stations={stations};
end

%%% Start process

for i=1:numel(stations)
    
    station=stations{i};
    
    [PHASES_SEL,ind_Phase]=get_PHASE(PHASES,'station',station);

    %%% Get times

    times=[PHASES_SEL(:).THEO]';
    windows={PHASES_SEL(:).AMP_WINDOW}';
    
    %%% Sort times ascending

    [times,ind]=sort(times);
    windows=windows(ind);

    PHASES_SEL=PHASES_SEL(ind);

    %%% Check that no overlapping and build new windows

    for i=1:length(times)-1

        time1=times(i);
        window1=windows{i};

        time2=times(i+1);
        window2=windows{i+1};
        
        if ~isempty(window1)
            if window1(2)>time2
                window1(2)=time2-coef*abs(time2-time1);
            end
        end
        
        if ~isempty(window2)
            if window2(1)<time1
                window2(1)=time1+coef*abs(time2-time1);
            end
        end
        windows{i}=window1;
        windows{i+1}=window2;

    end

    for i=1:length(PHASES_SEL)
       PHASES_SEL(i).AMP_WINDOW=windows{i};
    end

    PHASES(ind_Phase)=PHASES_SEL;

end

OUT=PHASES;

end
