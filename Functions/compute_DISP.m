% function made to add PZ info into the Data structure and to compute
% displacement
% 
% Input:
%     S: Structure Events Data
%     pz_file: file containing the pz info
%     
% Output:
%     out_S: Structure containing now pz infos

function out_S=compute_DISP(S,pz_file,mainfile)

PickerParam=readmain(mainfile);  
freq=PickerParam.R_freq;
PZ=read_PZ(pz_file);
DATA=S.DATA;

for i=1:numel(DATA)
    
    station=DATA(i).STAT;
    rsample=DATA(i).RSAMPLE;
    RAW=DATA(i).RAW;
    
    for j=1:length(RAW)
        if isfield(PZ,station) && isfield(PZ.(station),RAW(j).CHAN) && isfield(PZ.(station).(RAW(j).CHAN),RAW(j).COMP);
            RAW(j).POLES=PZ.(station).(RAW(j).CHAN).(RAW(j).COMP).poles;
            RAW(j).ZEROS=PZ.(station).(RAW(j).CHAN).(RAW(j).COMP).zeros;
            RAW(j).GAIN=PZ.(station).(RAW(j).CHAN).(RAW(j).COMP).gain;
           
            %%% Filter prior to correction
            
            RAW(j).CHAN;
            trace=RAW(j).TRACE;
            filt_trace=filterbutter(3,0.05,rsample/2-2,rsample,trace);
            
            poles=RAW(j).POLES;
            zes=RAW(j).ZEROS;
            gain=RAW(j).GAIN;
            freqref=1; % In Hz
            bad_vals=-2^31; % In case trace clipped
            
            %%% Apply correction
            
            prcdata = rm_instrum_resp(filt_trace,bad_vals,rsample,poles,zes,...
                0.5,rsample/2-1,3,3,1/gain,freqref,1,0);
            
            %%% filter aftercorrection
            
            prcdata=filterbutter(3,3,rsample/2-1,rsample,prcdata);
            
            RAW(j).DISP=prcdata;
            
            %%% Apply correction (!!! Don't put zero has the mean freq)
               
%             [RAW(j).DISP,~,~]=RawSeismicInstrumentCorrection(...
%                 fil_trace,...
%                 RAW(j).POLES,...
%                 RAW(j).ZEROS,...
%                 'rad', rsample,...
%                 1,rsample/2-2,...
%                 1./(RAW(j).GAIN),'r');
        end
    end
   
    DATA(i).RAW=RAW;
  
end

out_S=S;
out_S.DATA=DATA;

end