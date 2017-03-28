 RDMSEED Read miniSEED format file.
 	X = RDMSEED(F) reads file F and returns a M-by-1 structure X containing
 	M blocks ("data records") of a miniSEED file with headers, blockettes, 
 	and data in dedicated fields, in particular, for each data block X(i):
 		         t: time vector (DATENUM format)
 		         d: data vector (double)
 		BLOCKETTES: existing blockettes (substructures)
 
 	Known blockettes are 100, 500, 1000, 1001 and 2000. Others will be
 	ignored with a warning message.
 
 	X = RDMSEED(F,ENCODINGFORMAT,WORDORDER,RECORDLENGTH), when file F does 
 	not include the Blockette 1000 (like Seismic Handler outputs), specifies:
 		- ENCODINGFORMAT: FDSN code (see below); default is 10 = Steim-1;
 		- WORDORDER: 1 = big-endian (default), 0 = little-endian;
 		- RECORDLENGTH: must be a power of 2, at least 256 (default is 4096).
 	If the file contains Blockette 1000 (which is mandatory in the SEED 
 	convention...), these 3 arguments are ignored except with 'force' option.
 
 	X = RDMSEED without input argument opens user interface to select the 
 	file from disk.
 
 	[X,I] = RDMSEED(...) returns a N-by-1 structure I with N the detected 
 	number of different channels, and the following fields:
 	    ChannelFullName: channel name,
 	        XBlockIndex: channel's vector index into X,
 	         ClockDrift: vector of time interval errors, in seconds,
 	                     between each data block (relative to sampling
 	                     period). This can be compared to "Max Clock Drift"
 	                     value of a Blockette 52.
 	                        = 0 in perfect case
 	                        < 0 tends to overlapping
 	                        > 0 tends to gapping
 	  OverlapBlockIndex: index of blocks (into X) having a significant 
 	                     overlap with previous block (less than 0.5
 	                     sampling period).
 	        OverlapTime: time vector of overlapped blocks (DATENUM format).
 	      GapBlockIndex: index of blocks (into X) having a significant gap
 	                     with next block (more than 0.5 sampling period).
 	            GapTime: time vector of gapped blocks (DATENUM format).
 
 	RDMSEED(...) without output arguments plots the imported signal by 
 	concatenating all the data records, in one single plot if single channel
 	is detected, or subplots for multiplexed file (limited to 10 channels).
 	Gaps are shown with red stars, overlaps with green circles.
 
 	[...] = RDMSEED(F,...,'be') forces big-endian reading (overwrites the
 	automatic detection of endianness coding, which fails in some cases).
 
 	[...] = RDMSEED(F,...,'notc') disable time correction.
 
 	[...] = RDMSEED(F,...,'plot') forces the plot with output arguments.
 
 	[...] = RDMSEED(F,...,'v') uses verbose mode (displays additional 
 	information and warnings when necessary). Use 'vv' for extras, 'vvv'
 	for debuging.
 
 	Some instructions for usage of the returned structure:
 	
 	- to get concatenated time and data vectors from a single-channel file:
 		X = rdmseed(f,'plot');
 		t = cat(1,X.t);
 		d = cat(1,X.d);
 
 	- to get the list of channels in a multiplexed file:
 		[X,I] = rdmseed(f);
 		char(I.ChannelFullName)
 
 	- to extract the station component n from a multiplexed file:
 		[X,I] = rdmseed(f);
 		k = I(n).XBlockIndex;
 		plot(cat(1,X(k).t),cat(1,X(k).d))
 		datetick('x')
 		title(I(n).ChannelFullName)
 
 	Known encoding formats are the following FDSN codes:
 		 0: ASCII
 		 1: 16-bit integer
 		 2: 24-bit integer
 		 3: 32-bit integer
 		 4: IEEE float32
 		 5: IEEE float64
 		10: Steim-1
 		11: Steim-2
 		12: GEOSCOPE 24-bit (untested)
 		13: GEOSCOPE 16/3-bit gain ranged
 		14: GEOSCOPE 16/4-bit gain ranged
 		19: Steim-3 (alpha and untested)
 
 	See also MKMSEED to export data in miniSEED format.
 
 
 	Author: Fran�ois Beauducel <beauducel@ipgp.fr>
 		Institut de Physique du Globe de Paris
 	Created: 2010-09-17
 	Updated: 2014-06-29
 
 	Acknowledgments:
 		Ljupco Jordanovski, Jean-Marie Saurel, Mohamed Boubacar, Jonathan Berger,
 		Shahid Ullah, Wayne Crawford, Constanza Pardo, Sylvie Barbier,
 		Robert Chase, Arnaud Lemarchand.
 
 	References:
 		IRIS (2010), SEED Reference Manual: SEED Format Version 2.4, May 2010,
 		  IFDSN/IRIS/USGS, http://www.iris.edu
 		Trabant C. (2010), libmseed: the Mini-SEED library, IRIS DMC.
 		Steim J.M. (1994), 'Steim' Compression, Quanterra Inc.
