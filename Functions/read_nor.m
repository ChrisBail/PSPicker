function EVENT=read_nor(file,savefilename)

% Function made to read auto.out,collect or select.out files
% and make a structure 
% Input: select.out or collect.out file from seisan SELECT
% Events
%     ->date
%     ->depth
%     ->RMS
%     ->Cell->station;seconds;type;weight
% Access event by doing:
% B=cat(1,A(1).DATA(:).station)
% Do read_nor() to see what the structure looks like


if nargin==0
    EVENT=cell2struct(cell(21,1),{'year','month','day','fixtime','hour','min','sec','datenum',...
            'modelindic','distanceindic','lat','lon','depth','fixdepth','fixepic','agency',...
            'numbersta','rms','mag','typemag','magagency'},1);
    LINE=cell2struct(cell(21,1),{'station','type','component','quality',...
            'phase',...
            'weight',...
            'firstmotion',...
            'hour','min','sec','coda','amplitude',...
            'period','approach','velocity','incidence',...
            'AR','residual','weightcal','distance','azi'},1);
    ERROR=cell2struct(cell(5,1),{'t','x','y','z','COV'},1);
    EVENT.FOC=[];
    EVENT.ERROR=[];
    EVENT.WAV=[];
    EVENT.DATA=LINE;
    EVENT.ID=[];
    return
end

%%% Initialize waitbar

h = waitbar(0,'Please wait...reading records from nordic file');

V=read_nor();
EVENA(100000)=V;
flag_write=0;

if nargin==2
    flag_write=1;
end

fic=fopen(file,'r');
A=textscan(fic,'%s','delimiter','\n','whitespace','');
fclose(fic);
j=1;
k=0;
count=0;

for i=1:length(A{1})
    
    %%% Waitbar
    
    waitbar(i/numel(A{1}));
    
    %%% Start process

    line=A{1}{i};
    if isempty(A{1}{i})
        j=j+1;
        continue
    elseif strcmp(line(end),'1')
        k=0;
        if count>=1
            EVENA(count)=EVENT;
        end
        clear EVENT
        clear HEADER 
        clear F
        count=count+1;
        HEADER=read_line(line,1);
        HEADER.FOC=' ';
        HEADER.ERROR=cell2struct(cell(5,1),{'t','x','y','z','COV'},1);
        HEADER.WAV=' ';
        HEADER.DATA=[];
        HEADER.ID=[];
        EVENT=HEADER;
    elseif strcmp(line(end),'F')
        FOC=line;
        EVENT.FOC=FOC;
    elseif strcmp(line(end),'I')
        ID=read_line(line,'I');
        EVENT.ID=ID;
    elseif strcmp(line(end),'E')
        ERROR=read_line(line,'E');
        EVENT.ERROR=ERROR;
    elseif strcmp(line(end),'6')
        WAV=textscan(line,'%s',1);
        EVENT.WAV=WAV{1}{1};
    elseif strcmp(line(80),' ') && ~strcmp(line(2),' ') 
       k=k+1;
       F(k)=read_line(line,4);
       EVENT.DATA=F;
    else
        continue
    end
end
EVENA(count)=EVENT;
EVENT=EVENA(1:count);
if flag_write==1
    save(savefilename,'EVENT')
end

%%% Close waitbar

close(h)

end

function LINE=read_line(line,format)

% 2008 0601F0003 59.2 L -15.249 167.542 50.1FFVAN 12 0.3 1.8LVAN                1
%%% XXXX UUXXUXXUU UUUU X UUUUUUU XXXXXXXUUUUUXUXXXUUUXXXX UUUXUUU        
%%% 1    2 3 45 6  7    8 9       10      11   1213141516   17 1819  


%%% STAT SP IPHASW D HRMM SECON CODA AMPLIT PERI AZIMU VELO AIN AR TRES W  DIS CAZ7
%%% XXXXXUX UXXXXU X UUXX UUUUU XXXXUUUUUUU XXXX UUUUU XXXXUUUUXXXUUUUUXXUUUUU XXXU
%%% 1    23 45   6 7 8 9  10    11  12      13   14    15  16  17 18   1920    21 22     

% s=' XXXXXUX UXXXXU X UUXX UUUUU XXXXUUUUUUU XXXX UUUUU XXXXUUUUXXXUUUUUXXUUUUU XXXU';

switch format
    case 1
        %%% Scan line
        
        num_val={line(2:5);line(7:8);line(9:10);line(12:13);line(14:15);line(17:20);...
            line(24:30);line(32:38);line(39:43);...
            line(49:51);line(52:55);line(57:59)};
        fixtime=line(11);
        modelindic=line(21);
        distanceindic=line(22);
        fixdepth=line(44);
        fixepic=line(45);
        agency=line(46:48);
        typemag=line(60);
        magagency=line(61:63);
        C_char={fixtime,fixdepth,fixepic,agency,typemag,magagency};
        for i=1:length(C_char)
            if C_char{i}(1)==' '
                C_char{i}=[];
            end
        end
        [fixtime,fixdepth,fixepic,agency,typemag,magagency]=C_char{:};
        
        C_num=num2cell(str2double(num_val)');
        C_num(cellfun(@(x) any(isnan(x)),C_num))={[]};
        
        %%% Convert to matlab datenumber
        
        if ~isempty(C_num{6})
            date=datenum([C_num{1} C_num{2} C_num{3} C_num{4} C_num{5} C_num{6}]);
        else
            date=[];
        end
         
        %%% Make the structure
          
        LINE=cell2struct({C_num{1:3},fixtime,C_num{4:6},date,modelindic,distanceindic,C_num{7:9},fixdepth,fixepic,agency,...
            C_num{10:end},typemag,magagency},...
            {'year','month','day','fixtime','hour','min','sec','datenum',...
            'modelindic','distanceindic','lat','lon','depth','fixdepth','fixepic','agency',...
            'numbersta','rms','mag','typemag','magagency'},2);
    case 4
        %%% Scan line
% STAT SP IPHASW D HRMM SECON CODA AMPLIT PERI AZIMU VELO AIN AR TRES W  DIS CAZ7        
        station=strtrim(line(2:6));
        type=line(7);
        component=line(8);
        quality=line(10);
        phase=strtrim(line(11:14));
        weight=str2double(line(15));
        firstmotion=line(17);
        hour=str2double(line(19:20));
        min=str2double(line(21:22));
        sec=str2double(line(23:28));
        coda=str2double(line(30:33));
        amplitude=str2double(line(34:40));
        period=str2double(line(42:45));
        approach=str2double(line(47:51));
        velocity=str2double(line(53:56));
        incidence=str2double(line(57:60));
        AR=str2double(line(61:63));
        residual=str2double(line(64:68));
        weightcal=str2double(line(69:70));
        distance=str2double(line(71:75));
        azi=str2double(line(77:79));
        
        
        C_num={weight,hour,min,sec,coda,amplitude,period,approach,...
            velocity,incidence,AR,residual,weightcal,distance,azi};
        C_num(cellfun(@(x) any(isnan(x)),C_num))={[]};
        
        C_char={station,type,component,quality,phase,firstmotion};
        for i=1:length(C_char)
            if isempty(C_char{i}) | C_char{i}(1)==' ' 
                C_char{i}=[];
            end
        end
        [station,type,component,quality,phase,firstmotion]=C_char{:};
        
        %%% Make the strcuture

        LINE=cell2struct({station,type,component,quality,phase,...
            C_num{1},firstmotion,C_num{2:end}},{'station','type','component','quality',...
            'phase',...
            'weight',...
            'firstmotion',...
            'hour','min','sec','coda','amplitude',...
            'period','approach','velocity','incidence',...
            'AR','residual','weightcal','distance','azi'},2);
    case 'E'
        t=str2double(line(16:20));
        y=str2double(line(27:30));
        x=str2double(line(35:39));
        z=str2double(line(40:44));
        cxy=str2double(line(44:55));
        cxz=str2double(line(56:67));
        cyz=str2double(line(68:79));
   
        COV(1,1)=x.^2;
        COV(2,2)=y.^2;
        COV(3,3)=z.^2;
        COV(1,2)=cxy;
        COV(1,3)=cxz;
        COV(2,3)=cyz;
        COV=COV+triu(COV,1)';
        LINE=cell2struct({t,x,y,z,COV},{'t','x','y','z','COV'},2);
    case 'I'
        %line
        id=strtrim(line(61:75));
        LINE=id;
    otherwise
        disp('wrong format for reading line');
end

end



