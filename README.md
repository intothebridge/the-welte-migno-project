# the-welte-mignon-project
From piano roll to midi (thanks to supra) to a brandnew Steinway (thanks to pianoteq)
Goal:
* batch convert the midi files (based on historic piano rolls) provided by the supra dataset to high quality mp3 piano music

## Prerequisites

* a linux shell (bash) and some opensource tools (see below) which easily can be installed
* a version of pianoteq installed, see https://www.modartt.com/pianoteq_overview - this is a *commercial piano sound generator* which can be used "headless" on the command line (I am using pianoteq "stage")
* app. 10 GB of disk space for the final mp3-files

Pianoteq is also available as free to try - only difference to licensed version is that some notes will not play.

# Step by Step Howto

## 1. Download the supra dataset from github

The "supra dataset" is provided by Stanford University, download it from here: https://github.com/pianoroll/SUPRA
* you need the metadata files (.marcxml) and the midi-files (I recommend taking the "expressive midi" files.

Be aware that although this work is free, there is a copyright to be mentioned:
If using this dataset, please cite the following paper:
Zhengshan Shi, Craig Stuart Sapp, Kumaran Arul, Jerry McBride, Julius O. Smith III. SUPRA: Digitizing the Stanford University Piano Roll Archive. In Proceedings of the 20th International Society for Music Information Retrieval Conference (ISMIR), pages 517-523, Delft, The Netherlands, 2019.

# Prepare your working directory

Create one single working folder (for easier processing) and copy all midi and xml files to this folder.
Doing this give a total of 480 xml files and the same number of midi files.

Download "xidel" for xml-Processing

Copy "lame" (/usr/bin/lame) to this working dir - pianoteq needs this for creating mp3s and is looking for it simply in the current folder.

Make pianoteq-executable available: I created a symlink in a PATH-directoy or create a symlink to pianoteq in your working directory.

Decide which preset you want to use. To get the correct naming use:
$ pianoteq --list-presets

Install or make available a id3-processor. I found issueing "apropos id3" that mid3v2 is installed on my fedora workstation, so I am using that (and integrating it into my conversion script).

Copy my conversion script from github (a single bash file) to your working directory:

* set the preset you want to use in the parameters

# Start with test data

To test and time the process, I moved all midi-xml-pairs into a subdir and only left 3 pairs in the working dir to try the process first on these before starting hours of conversion on my laptop.
