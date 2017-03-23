% function made to homogenise the traces, so that they have the same length
% and the same timestart

function new_DATA=uniform_DATA(DATA)

    for i=1:length(DATA)

        DAT=DATA(i);

        %% Get timestarts

        f={DAT.RAW.TRACE};
        timestarts=[DAT.RAW.TIMESTART];
        rsample=DAT.RSAMPLE;

        %% Merge arrays

        [out_timestart,f_out]=merge_array(timestarts,f,rsample);

        %% Store in structure

        for j=1:length(DAT.RAW)
            DAT.RAW(j).TIMESTART=out_timestart;
            DAT.RAW(j).TRACE=f_out(:,j);
        end

        DATA(i)=DAT;

    end

    new_DATA=DATA;
    
end




