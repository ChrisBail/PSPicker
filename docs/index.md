# PSPicker Cookbook

Christian Baillard  
baillard@geologie.ens.fr or baillard@uw.edu

The purpose of this cookbook is to describe the workflow for automatic picking refinement using the Matlab based library **PSPicker**.

# Goal

PSPicker is a Matlab library designed to improve location of events by both refining the P and S onset times and integrating more arrivals into the problem. Typically, if the user has a poor quality catalog, with unaccurrate picks, PSPicker is definitely the right tool!


# Pre-requist

* [HYPOCENTER](hypocenter.md)
* [dataselect](dataselect.md)
* [ObsPy](https://github.com/obspy/obspy/wiki) 

# Get the Package

Nothing is more easy! Just go into the [github repo](https://github.com/ChrisBail/PSPicker) and clone it on your computer (for example in /home/toto/program/).

# What's inside the package?

In PSPicker repo you will find:  
* `main.m` which is the main script that performs automatic picking/relocation/cleaning...
* `Functions/` directory that includes all functions
* [`mainfile.txt`](mainfile.md) which is the main configuration file.
* `example/` directory which is meant to give you a quick overview of PSPicker possibilities given real data. Inside it you will find:
	* `SDS/` directory (which contains all the MSEED files stored in a SEISCOMP Data Structure)
	* `initial.nor`, file containing preliminary locations and phases intended to be reprocessed using PSPicker Library.
	* `mainfile.txt`, configuration file tuned for example.
	* `STATION0.HYP`, file containg station locations and velocity model used by HYPOCENTER location program.
	* `stations_PZ.txt`, instrument response file (used for amplitude calculation.
	* `test_function`, example file to run automatic picking. Just run `test_function` in the command window.
	* `EVENT.mat`,`trace_P.mat`,`trace_S.mat` are data files that can be used to test PSPicker functions. 
* `docs/` directory containing all the docs (including this one ;) ).
* `screenshots/` directory (straightforward!).
* README.md
 

NOTES: STATION0.HYP is the parameter file used by HYPOCENTER used by SEISAN, for any details please refer to the the SEISAN user’s guide. STATION0.HYP regroups geographical locations of all stations of the network (name, lon, lat, altitude, station correction if we have it) and also the 1D velocity model we are using. The way the 1D model is given is really similar to what we have in hypo71 for those who are familiar with it. In details we specify the P-velocity at each user’s specified depth, then we give the Vp/Vs ratio, and then we specify the distance’s based weighting scheme used by the locator. In more simple way, we specify the weights of each arrivals based on the station-epicenter distance, the closer the station is, the more weight we put on the corresponding arrival.


# System requirement 
PSPicker mostly uses Matlab scripts and functions (except [HYPOCENTER](hypocenter.md) and [dataselect](dataselect.md)). The computational cost of the software is small, an 8 GB internal memory computer will run the program easily. The main script is based on a major loop that processes each events of the catalog one by one and outputs the results directly in a file so that even if it crashes, every event processed is kept into the hard drive. Even if we tried as hard as possible to avoid using the Matlab signal processing toolbox some of these functions are still call by PSPicker. We recommend to use Matlab 2015.

# Usage

Before anything don't forget to `addpath(genpath(path/to/functions))` if you want to use PSPicker library from other directory than the current directory. The current directory you're working in should always have a `mainfile.txt` in it.  
The program PSPicker is launched through one single script called `main.m` that reads the `mainfile.txt`. Every paramters/inputs are given in the configuration file `mainfile.txt` and detailed [here](mainfile.md). The input of `main.m` is a nordic file .nor (specific file format used by SEISAN) that has a preliminary location and phase arrivals for each event. Each event contained in the .nor file will be converted to a single structure called EVENT. EVENT is the most important structure of the program, it contains all the info associated to that event, e.g. location, origin time, magnitude, phases arrivals, type of phases... PSPicker will thus process all the events (re-pick phases, update location, compute magnitude) and return a final EVENT structure of size m where m is the number of events in your final catalog. At the end of the process, PSPicker will convert the EVENT structure in a .nor output file.

**So to recap: Input file in .nor format > PSPicker > Output file in .nor format**


# Most important functions

 One should understand that PSPicker is not only one single magic script that performs all the picking automatically. Of course `main.m` is intented to do that, but it can and should be changed to suit your need. PSPicker should be seen as a library of functions to automatically pick phase, reject mis-picks, compute amplitude.... Not all functions are directly useful for the user but some of them are really important.

* **refine_PICKS**: Probably the most important function of the PSPicker library. It takes one single `EVENT` structure with preliminary location and picks and the `mainfile.txt` as input and outputs a new `EVENT` with updated picks and location. In details this is what `refine_PICKS` does:  
	1. Relocate the event using `hyp` to compute theoretical P and S arrival times on all stations of the network.
	2. Extract the MSEED files from the SDS to get a single MSEED file. This is performed by `sds2mseed`. 
	3. Compute the Kurtosis on specified channels to find P and S picks. This is performed by `trace2FWkurto` and `follow_extrem2`.
	4. Estimate weight for each picks based on SNR or Kurtosis value.
	5. Relocate the event using newly defined automatic picks.  
Note: No cleaning of mispicks is performed by `refine_PICKS`, this is done by `rmsta_EVENT` and `rmres_EVENT`.

* **trace2FWkurto**: This function transforms any time series into Kurtosis Characteristic Functions (CFs). FW stand for Frequency/Window. Computation of this function is explained in [Baillard et al., 2014](http://www.bssaonline.org/content/104/1/394.short). To sum up, the Kurtosis is computed using all possible combinations of frequency and window sizes. Small windows will be more sensitive to small onsets but the resulting Kurtosis will be more noisy. The function outputs all possible combinations of Kurtosis CF but also the stack of all Kurtosis CFs. Picking the minimum (performed by `follow_extrem2` on the CF will be give you the expected phase onset. 
 
* **follow_extrem2**: This function is `trace2FWkurto`'s best buddy! It takes all the CFs and picks the minimum on all CFs using a coarse to fine approach, i.e. it will first start to pick the minimum on the Kurtosis CF associated to the biggest window then it will track this minimum on subsequent Kurtosis CFs, to get a fine estimate of the onset.  


# API description

Please check [here](api_list.md) to have a complete list of functions and associated descriptions


# Contribution

You are warmly welcomed to contribute to this project using the utilities provided by github (pull requests).  

