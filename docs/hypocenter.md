HYPOCENTER is the location algorithm used in PSPicker, it takes as input:
* A station file `STATION0.HYP` where the 1D P-Velocity model is defined inside it
* A nordic file .nor with one (or multiple) event(s)

HYPOCENTER is shipped with [SEISAN](http://seisan.info/) and referred as `hyp`. Please refer to the SEISAN installation cookbook for details.
* untar SEISAN.tar.gz
* go to SEISAN/PRO/
* test HYPOCENTER by doing ./hyp

If you downloaded the source, sometimes you can have a problem with `tau.for` and `hyp` crashes with the following message:
`At line 1635 of file tau.for (unit = 22, file = '/home/seismic/SEISAN/DAT/IASP91_linux.HED')
Fortran runtime error: End of file`.
This is because `hyp` uses IASP tables for global locations problems, even if we are not using these tables, `hyp` requests them to be present. Just do `remodl` and `setbrn` to regenerate the tables.

troubleshooting: `hyp` has sometimes problem to link to an old libgfotran.so.1. In that case you have to recompile programs.  
* in PRO/ do `make clean`
* sudo apt-get install libx11-dev
* make all

The path where `hyp` is installed is given as an input in the [mainfile.txt](mainfile.md) configuration file
