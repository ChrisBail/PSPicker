#!/bin/bash

# The program is made to extract mseed from a SDS archive by specifying
# the requested station, time, sds path , component and network.
# If no station/comp/network is specified it'll take all the avalaible sta/comp/net in the directory
# It's possible to define several stations comp or netw by writing` -sta "Station1,Station2"`

# First check that dataselect is installed on PC, if not abort

command -v dataselect >/dev/null || { echo "dataselect command not found. \
Install it and export it to your PATH in .bashrc"; exit 1; }

# Start program

list_file="scratch.file"

rm -f $list_file

### Set flags

station_flag=true
comp_fag=true
network_flag=true

if [[ $# == 0 ]]; then
	printf "Command line should be:\n\
./sds2mseed.sh -start \"2015-05-01 00:00:00\" -end \"2015-05-01 00:30:00\" \
-sta \"DANN,TAPN\" -comp \"Z\" -duration \"3600\" -comp \"SHZ\" \
-sds \"/Volumes/donnees/SDS/\" -o extract.mseed\n"
	exit
fi
	

while [[ $# > 1 ]]
do

key="$1"
echo $key

case $key in
	-o)
	output="$2"
	shift
	;;
	-n)
	network="$2"
	shift
	;;
	-comp)
	comp="$2"
	shift
	;;
	-sta|--station)
	station="$2"
	shift
	;;
    -start|--start_time)
    start_time="$2"
    shift # past argument
    ;;
    -duration)
    duration="$2"
    shift # past argument
    ;;
    -end|--end_time)
    end_time="$2"
    shift # past argument
    ;;
    -sds|--sds_path)
    sds_path="$2"
    shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

### Exit if non-optionnal argument are not set (start time, end time, sds_path)

if [[ -z ${sds_path} ]] || [[ -z ${start_time} ]] || [[ -z ${output} ]]; then
	printf "One or more of the required arguments '-start', '-end', '-sds' or '-o' is (are) not set\nExit\n"
	exit
fi
if [[ -z ${end_time} ]] && [[ -z ${duration} ]]; then
	printf "duration set\nExit\n"
	exit
fi


## Reset flags

if [ -z ${station} ]; then
	station_flag=false
	station="*" # Wild card for searching though the paths
fi

if [ -z ${network} ]; then
	network_flag=false
	network="*"
fi

if [ -z ${comp} ]; then
	comp_flag=false
	comp="*"
fi

## Put values in arrays

IFS=', ' read -a station <<< "$station"
IFS=', ' read -a network <<< "$network"
IFS=', ' read -a comp <<< "$comp"

### Start processing

echo start_time  = "${start_time}"
echo sds_path    = "${sds_path}"

### Define new endtime based on offset

if [ -n "$duration" ]; then
	secs_offset=$(date +%s -d "$start_time")
	end_time=`date +"%F %T" -d "@$((secs_offset + duration))"`
fi

#sds_path='/Volumes/donnees/SDS/'


### Get the julian day of first and last year

# On linux platform

julian_day_start=`date -d "$start_time" "+%j"`
julian_day_end=`date -d "$end_time" "+%j"`
year_start=`date -d "$start_time" "+%Y"`
year_end=`date -d "$end_time" "+%Y"`

# On mac platform

#julian_day_start=`date -j -f "%Y-%m-%d %H:%M:%S" "$start_time" "+%j"`
#julian_day_end=`date -j -f "%Y-%m-%d %H:%M:%S" "$end_time" "+%j"`
#year_start=`date -j -f "%Y-%m-%d %H:%M:%S" "$start_time" "+%Y"`
#year_end=`date -j -f "%Y-%m-%d %H:%M:%S" "$end_time" "+%Y"`


### Get the year

#start_year=`date -j -f "%Y %M %d" "2010 01 01" "+%s"`
#scratch=`date -j -f "%Y %M %d" "2010 05 21" "+%s"`

#num=$(( ($scratch - $start_year) / 86400 ))

for (( j=year_start; j<=year_end; j++ )); do
	if [ $j != $year_end ]; then
		end_day=365
	else
		end_day=julian_day_end
	fi
	if [ $j != $year_start ]; then
		first_day=1
	else
		first_day=julian_day_start
	fi
 
	for ((i=first_day; i<=end_day; i++)); do 
		# Write path to data
		for station_s in "${station[@]}"; do 
		
			for comp_s in "${comp[@]}"; do 
			
				for network_s in "${network[@]}"; do 
			
					declare -a data_path=(`printf "%s%s/%s/%s/%s.D/" $sds_path $j "$network_s" "$station_s" "$comp_s"`)
					wav_name=`printf "*%s.%s" $j $i`
					for data_path in "${data_path[@]}"; do
					#echo "$station"
					# define wav name and check if exist
						if [ -e $data_path$wav_name ] && [ -s $data_path$wav_name ] ; then
							echo $data_path$wav_name >> $list_file
							printf "... Processing %s \n" $data_path$wav_name
						else
							printf "Wave name      %s does not exist\n" $data_path$wav_name 
						fi
					done
				done
			done
		done				
	done
done

### Run data_select

# Linux platform

dataselect_start=`date -d  "$start_time" "+%Y.$julian_day_start.%H.%M.%S"`
dataselect_end=`date -d "$end_time" "+%Y.$julian_day_end.%H.%M.%S"`

# Mac platform 

#dataselect_start=`date -j -f "%Y %m %d %H:%M:%S" "$start_time" "+%Y.$julian_day_start.%H.%M.%S"`
#dataselect_end=`date -j -f "%Y %m %d %H:%M:%S" "$end_time" "+%Y.$julian_day_end.%H.%M.%S"`

#echo "dataselect @$list_file -ts "$dataselect_start" -te "$dataselect_end" -o cat.mseed"
dataselect @$list_file -ts "$dataselect_start" -te "$dataselect_end" -o $output






