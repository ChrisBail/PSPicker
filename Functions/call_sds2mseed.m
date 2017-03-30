function call_sds2mseed(cmd_string)
    %Function made to call sds2mseed.sh bash script

    full_path=which('call_sds2mseed');
    [dir_path,~,~] = fileparts(full_path);

    sds2mseed_function=[dir_path,'/sds2mseed.sh'];

    [~,~]=system([sds2mseed_function,' ',cmd_string]);

end
