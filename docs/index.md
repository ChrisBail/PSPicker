# PSPicker Cookbook

Christian Baillard
baillard@geologie.ens.fr or baillard@uw.edu

The purpose of this cookbook is to describe the workflow for automatic picking refinement using the Matlab based scrpit PSPicker.

# Goal

PSPicker is designed to improve location of events by both refining the P and S onset times and integrating more arrivals into the problem. Typically, if the user has a poor quality catalog, with unaccurrate picks, PSPicker is definitely the right tool!

In details, PSPicker will compute theoretical travel times based on a simple 1D velocity model, then try to improve/find onsets in the vicinity of absolute theoretical arrival times.

# Pre-requist

* [HYPOCENTER](hypocenter.md)
* [dataselect](dataselect.md)

# System requirement 
PSPicker mostly uses Matlab scripts and functions (except [HYPOCENTER](hypocenter.md) and [dataselect](dataselect.md)). The computational cost of the software is small, an 8 GB internal memory computer will run the program easily. The main script is based on a major loop that processes each events of the catalog one by one and outputs the results directly in a file so that even if it crashes, every event processed is kept into the hard drive. Even if we tried as hard as possible to avoid using the Matlab signal processing toolbox some of these functions are still call by PSPicker. We recommend to use Matlab 2015.

# Usage

The program PSPicker is launched through one single script called `main.m` that reads the `mainfile.txt`. Every paramters/inputs are given in the configuration file `mainfile.txt` and detailed here. The input of `main.m` is a nordic file .nor (specific file format used by SEISAN) that has a preliminary location and phase arrivals for each event. Each event contained in the .nor file will be converted to a single structure called EVENT. EVENT is the most important structure of the program, it contains all the info associated to that event, e.g. location, origin time, magnitude, phases arrivals, type of phases... PSPicker will thus process all the events (re-pick phases, update location, compute magnitude) and return a final EVENT structure of size m where m is the number of events in your final catalog. At the end of the process, PSPicker will convert the EVENT structure in a .nor output file.

**So to recap: Input file in .nor format > PSPicker > Output file in .nor format**

# Basic worflow

Dwlnm
where to work
run
PSPicker.tar.gz which contains all the internally built functions to run PSPicker. The program can be downloaded at www.test.fr or can be sent to you by contacting baillard@geologie.ens.fr. 3.Installation of software and dependencies 3.1.Installation of PSPicker 1.Go to your desired working directory where you will run PSPicker. For example /home/smith/work/ 2.Copy paste PSPicker.tar.gz into the chosen directory 3.Extract the archive: tar -xvzf PSPicker.tar.gz 4.Start Matlab from the terminal (so that the bash environment is loaded) and go to /home/smith/work/PSPicker/. You will find: ­main.m which is the main script containing the loop ­Functions/ directory that includes all functions called by main.m ­mainfile.txt which is the main configuration file ­stations_PZ.txt that contains Gain and poles and zeros for each channel. ­STATION0.HYP which is the parameter file (containing station coordinates and velocity model) need by HYPOCENTER. 3.2.Installation of SEISAN As stated before, PSPicker uses the HYPOCENTER program delivered by SEISAN to perform inversion. HYPOCENTER, contrary to hypo71, integrates elevation of stations. Please refer to the installation guide delivered with SEISAN to install the software. The HYPOCENTER program is referred as hyp. Please note carefully the path where you installed hyp as it is required in the mainfile.txt configuration file (see section Main configuration file: mainfile.txt).

4.Description of Main files 4.1.Main script: main.m

4.2.Main configuration file: mainfile.txt This is the only configuration file required to run PSPicker. All parameters that should be tuned are listed here. Normally, the user doesn’t need to go into the functions themselves (except main.m, we’ll see that later, no worry!).

Find below the detailed list of parameters used by PSPicker:

­Input_nordic: name of the nordic file or name of the directory containing the nordic files to be processed. In the case of a directory, all files with extension .nor will be listed. PSPicker will loop over the nordic files listed. Please avoid to process big nordic files (> 1000 events) as all events are converted into one single structure, it’s better to cut the input files (for example it takes ~1s to store 100 events with 10 recordings into the event structure).

­Sds_path: path to the Seicomp Data Structure (SDS) containing daily mseed files. Based on phase arrivals, PSPicker will create one single mseed file containing all the desired traces extracted from the SDS archive. The time length of the extracted data is specified by extract_time.

­Hyp: specify the location of the HYPOCENTER program “hyp” shipped with SEISAN (it’s basically where you installed SEISAN, but of course it can be somewhere else).

­Sfile_folder: Directory where all output nordic files re-processed by PSPicker will be stored. There will be one single nordic file per event. Afterwards, all nordic files can be concatenated into one single “phase catalog” file (using a simple cat *.nor).

4.3.Main station file: station_PZ.txt 4.4.Main location file: STATION0.HYP This file allows location of events from phase arrivals. It’s the parameter file of HYPOCENTER used by SEISAN, for any details please refer to the the SEISAN user’s guide. As we used HYPOCENTER for primar locations and update of the solutions after refining the picks we need this file in the working directory.

To sum up, STATION0.HYP regroups geographical locations of all stations of the network (name, lon, lat, altitude, station correction if we have it) and also the 1D velocity model we are using. The way the 1D model is given is really similar to what we have in hypo71 for those who are familiar with it. In details we specify the P-velocity at each user’s specified depth, then we give the Vp/Vs ratio, and then we specify the distance’s based weighting scheme used by the locator. In more simple way, we specify the weights of each arrivals based on the station-epicenter distance, the closer the station is, the more weight we put on the corresponding arrival.

Inputs & Outputs Workflow The SDS architecture Working with seiscomp: From xml to nordic files Main programs

List of programs


