[dataselect](https://github.com/iris-edu/dataselect) is an IRIS code made to select and cut waveforms depending on user given parameters
Please follow dataselect's user guide to make the executables.
Once you have compiled `dataselect` you HAVE TO add it to your $PATH in your .bashrc so that functions calling `dataselect` can work without giving the whole path to it.
This is particulary the case for `sds2mseed.sh` which calls `dataselect` to look for specific MSEED files in the SEISCOMP Database Structure [SDS](https://www.seiscomp3.org/wiki/doc/applications/slarchive/SDS) and will output one MSEED containing all the desired channels.

The MSEED file will be read into matlab using [rdmseed.m](https://www.mathworks.com/matlabcentral/fileexchange/28803-rdmseed-and-mkmseed--read-and-write-miniseed-files?requestedDomain=www.mathworks.com)
