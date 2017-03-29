# PSPicker Cookbook

Christian Baillard  
baillard@geologie.ens.fr or baillard@uw.edu

The purpose of this cookbook is to describe the workflow for automatic picking refinement using the Matlab based script PSPicker.

# Goal

PSPicker is designed to improve location of events by both refining the P and S onset times and integrating more arrivals into the problem. Typically, if the user has a poor quality catalog, with unaccurrate picks, PSPicker is definitely the right tool!

In details, PSPicker will compute theoretical travel times based on a simple 1D velocity model, then try to improve/find onsets in the vicinity of absolute theoretical arrival times.

# Pre-requist

* [HYPOCENTER](hypocenter.md)
* [dataselect](dataselect.md)

# System requirement 
PSPicker mostly uses Matlab scripts and functions (except [HYPOCENTER](hypocenter.md) and [dataselect](dataselect.md)). The computational cost of the software is small, an 8 GB internal memory computer will run the program easily. The main script is based on a major loop that processes each events of the catalog one by one and outputs the results directly in a file so that even if it crashes, every event processed is kept into the hard drive. Even if we tried as hard as possible to avoid using the Matlab signal processing toolbox some of these functions are still call by PSPicker. We recommend to use Matlab 2015.

# Usage

The program PSPicker is launched through one single script called `main.m` that reads the `mainfile.txt`. Every paramters/inputs are given in the configuration file `mainfile.txt` and detailed [here](mainfile.md). The input of `main.m` is a nordic file .nor (specific file format used by SEISAN) that has a preliminary location and phase arrivals for each event. Each event contained in the .nor file will be converted to a single structure called EVENT. EVENT is the most important structure of the program, it contains all the info associated to that event, e.g. location, origin time, magnitude, phases arrivals, type of phases... PSPicker will thus process all the events (re-pick phases, update location, compute magnitude) and return a final EVENT structure of size m where m is the number of events in your final catalog. At the end of the process, PSPicker will convert the EVENT structure in a .nor output file.

**So to recap: Input file in .nor format > PSPicker > Output file in .nor format**

# Basic worflow

Clone the gitbut repository to your computer.   
Go to your desired working directory where you will run PSPicker. For example /home/smith/work/PSPicker.   
You will find:  
* main.m which is the main script containing the loop
* Functions/ directory that includes all functions called by main.m
* mainfile.txt which is the main configuration file
* stations_PZ.txt that contains Gain and poles and zeros for each channel.  
* STATION0.HYP which is the parameter file (containing station coordinates and velocity model) needed by HYPOCENTER. 

STATION0.HYP This file allows location of events from phase arrivals. It’s the parameter file of HYPOCENTER used by SEISAN, for any details please refer to the the SEISAN user’s guide. As we used HYPOCENTER for primar locations and update of the solutions after refining the picks we need this file in the working directory.

To sum up, STATION0.HYP regroups geographical locations of all stations of the network (name, lon, lat, altitude, station correction if we have it) and also the 1D velocity model we are using. The way the 1D model is given is really similar to what we have in hypo71 for those who are familiar with it. In details we specify the P-velocity at each user’s specified depth, then we give the Vp/Vs ratio, and then we specify the distance’s based weighting scheme used by the locator. In more simple way, we specify the weights of each arrivals based on the station-epicenter distance, the closer the station is, the more weight we put on the corresponding arrival.


# API description

Please check [here](api_list.md) to have a complete list of functions and associated descriptions




