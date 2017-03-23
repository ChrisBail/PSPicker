%%% Function amde to read STATION0.HYP file
% Input:    station_file > Name of station file
% Output:   STA > Cell with name,lon,lat(decimal),depth(m)

function STA=read_STATION0HYP(station_file)

%station_file='/Volumes/donnees/SE_DATA/DAT/STATION0.HYP';

%%% Read station_file

foc=fopen(station_file,'rt');
k=0;
count=0;
while ~feof(foc)
    line=fgetl(foc);
    if (numel(line)>14) && (line(14)=='N' || line(14)=='S')
        k=k+1;
        if strcmp(line(1),'-')
            signedepth=-1;
        else
            signedepth=1;
        end
        if strcmp(line(14),'S')
            signelat=-1;
        else
            signelat=1;
        end
        if strcmp(line(23),'W')
            signelon=-1;
        else
            signelon=1;
        end
        
        if strcmp(line(11),'.')
            lat=str2num(line(7:8))+str2num(line(9:13))./60;
        else
            lat=str2num(line(7:8))+str2num([line(9:10),'.',line(11:13)])./60;
        end
        if strcmp(line(20),'.')
            lon=str2num(line(15:17))+str2num(line(18:22))./60;
        else
            lon=str2num(line(15:17))+str2num([line(18:19),'.',line(20:22)])./60;
        end
        
        STA(k,1)={strtrim(line(2:6))};
        STA(k,3)={signelat*lat};
        STA(k,2)={signelon*lon};
        depth=str2num(line(24:27))/1000;
        STA(k,4)={signedepth*depth}; 
    end
end

fclose(foc);

end