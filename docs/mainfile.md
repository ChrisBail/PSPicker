
Here you'll get a description of all parameters contained in main configuration file `mainfile.txt`. This is the only configuration file required to run PSPicker. All parameters that should be tuned are listed here. Normally the user doesn’t need to go into the functions themselves (except `main.m`, we’ll see that later, no worry!).

Find below the detailed list of parameters used by PSPicker:

­Input_nordic: name of the nordic file or name of the directory containing the nordic files to be processed. In the case of a directory, all files with extension .nor will be listed. PSPicker will loop over the nordic files listed. Please avoid to process big nordic files (> 1000 events) as all events are converted into one single structure, it’s better to cut the input files (for example it takes ~1s to store 100 events with 10 recordings into the event structure).

­Sds_path: path to the Seicomp Data Structure (SDS) containing daily mseed files. Based on phase arrivals, PSPicker will create one single mseed file containing all the desired traces extracted from the SDS archive. The time length of the extracted data is specified by extract_time.

­Hyp: specify the location of the HYPOCENTER program “hyp” shipped with SEISAN (it’s basically where you installed SEISAN, but of course it can be somewhere else).

­Sfile_folder: Directory where all output nordic files re-processed by PSPicker will be stored. There will be one single nordic file per event. Afterwards, all nordic files can be concatenated into one single “phase catalog” file (using a simple cat *.nor).
