
Here you'll get a description of all parameters contained in main configuration file `mainfile.txt`. This is the only configuration file required to run PSPicker. All parameters that should be tuned are listed here. Normally the user doesn’t need to go into the functions themselves (except `main.m`, we’ll see that later, no worry!).

Find below the detailed list of parameters used by PSPicker:

* **input_nordic**: name of the nordic file or name of the directory containing the nordic files to be processed. In the case of a directory, all files with extension .nor will be listed. PSPicker will loop over the nordic files listed. Please avoid to process big nordic files (> 1000 events) as all events are converted into one single structure, it’s better to cut the input files (for example it takes ~1s to store 100 events with 10 recordings into the event structure).

* **sds_path**: path to the Seicomp Data Structure (SDS) containing daily mseed files. Based on phase arrivals, PSPicker will create one single mseed file containing all the desired traces extracted from the SDS archive. The time length of the extracted data is specified by `extract_time`.

* **hyp**: specify the location of the HYPOCENTER program `hyp` shipped with SEISAN (it’s basically where you installed SEISAN, but of course it can be somewhere else).

* **station_file**: path to the STATION0.HYP file used by `hyp`, containing station coordinates info and velocity model info.   

* **sfile_folder**: Directory where all output nordic files re-processed by PSPicker will be stored. There will be one single nordic file per event. Afterwards, all nordic files can be concatenated into one single “phase catalog” file (using a simple cat *.nor).

* **extract_time**: time values [T1 T2] in sec to extract the MSEED file from the SDS. PSPicker will check for the first (Tf) and last arrival times (Tl) (theo) for each event then it will extract between [Tf-T1 Tl+T2]

* **SNR_freq**: frequency band applied to the trace prior to SNR computation. SNR computation is made to check if trace presents sufficently high SNR to be picked and also serves for weighting of picks.

* **SNR_wind**: Long Term and Short Term window sizes in sec to compute SNR. SNR computation works like the STA/LTA.

* **window_max_S**: Boolean to define whether or not the right-hand side of the S-window should be reevaluated and associated to the maximum energy. It looks for the maximum energy into the interval defined by window_S.   

* **window_P**: Window (sec) around the P phase absolute arrival times to compute the kurtosis and look for a new pick.   

* **window_S**: Same as before but for S phase.   

* **max_drift**: Maximum drift (sec) allowed to find a local minimum on the Kurtosis Characteristic Function (CF) on the left hand side of the global minimum. Usually 10 samples converted into sec is a good value. The search of a local minimum on the CF is performed by f unction `follow_extrem2`.  

* **KURTO2W_P**: Array used for conversion from Kurtosis CF amplitudes to hypo71 weight for the P-phase. The higher the value the better the weight (perfect pick > weigth = 0).  

* **KURTO2W_S**: Same as before but for S-phase.  

* **SNR2W_P**: Array used for conversion from SNR to hypo71 weight for the P-phase.

* **SNR2W_S**: Same as before but for the S-phase.

* **weight_switch**: Choose if you want to weight the picks based on the SNR method or the Kurtosis method. In general, weighting the picks based on SNR is more reliable.  

* **minphase_amp**: Minimum number of amplitudes required to give an magnitude. Amplitudes are obtained by taking the maximum amplitude of a given channel around a specified pick (P or S).  


Parameters specific for each station and each pick are given in the next section of the mainfile.txt. Some of the parameters are deprecated but for each stattion we have:   

* **stat**: Station name, should be the same as given by the waveform (otherwise won't be able to read it).  

* **Pick**: Phase type (for the moment only P or S can be given).

* **Chan**: Channel ID on which the picking will be performed. Multiple channels can be given. PSPicker will pick on each of these channels and only keep the pick that shows the highest SNR or Kurtosis CF.

* **f_energy**: deprecated.   

* **freqs**: Letter that points to the desired frequencies. We use letters just to have a clearer configuration file. example: A=[1 10;1 15], which means the Kurtosis will be computed on two bandpassed filtered traces [1 10] and [1 15]. Final Kurtosis is just a stack of all the Kurtosis obtained on each filterd traces.

* **window**: Letter that points to the desired windows. example B=[1 2 5]. Window sizes are given in sec. For each window we will compute a Kurtosis. Remember that the bigger the window the less sensitive is the Kurtosis to small/localized onsets. PSPicker will first pick the minimum of the Kurtosis associated to the biggest window, then, it will start to track this minimum on subsequent Kurtosis until it reaches the Kurtosis associated with the smallest window. We perform a coarse to fine scale approach to be sure we retrieve the true onset on the trace.  

Other parameters are for the moment no longer used by PSPicker! However they still should be defined as PSPicker is looking for 11 fields per station (this will be chnaged soon).  
