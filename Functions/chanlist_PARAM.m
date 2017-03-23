
function channelIDS=chanlist_PARAM(PickerParam)
%%% List all channels that need to be processed

channelIDS={};
for station=fieldnames(PickerParam.Station_param)';
    for type=fieldnames(PickerParam.Station_param.(station{1}))';
        if ~isempty(PickerParam.Station_param.(station{1}).(type{1}))
            for phase=fieldnames(PickerParam.Station_param.(station{1}).(type{1}))';
                channelID=PickerParam.Station_param.(station{1}).(type{1}).(phase{1}).channelID;
                channelIDS=[channelIDS channelID];
            end
        end
        
    end 
end

channelIDS=unique(channelIDS);

end
