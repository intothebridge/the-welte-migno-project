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

## Prepare your working directory

Create one single working folder (for easier processing) and copy all midi and xml files to this folder.
Midi and XML-Files are organized into subfolders according to the first letter of the filenames.
Filenames are kind of IDish, like  "bb988jx6754.marcxml" and "bb988jx6754_exp.mid"
Doing this give a total of more than 400 xml files and the same number of midi files.

## Download the XML-Tool "xidel" for xml-Processing

Xidel is an opensource XML-parser. 
Xidel is a single binary that you can download for linux or windows from here: https://www.videlibri.de/xidel.html
I placed xidel into my local directory */home/user/bin*, which is included in the PATH environment.

## Copy the lame executable to your working directory

Pianoteq headless requires for converting to mp3 the lame-executable. PATH is not resolved. Pianoteq only looks in the current directory, so I simply copied the binary to the working dir.
Find out where lame resides by issueing
@$ which lame@
which yields on my system: */usr/bin/lame*

## Make the pianoteq-executable available

Happily also pianoteq is a single binary:
To make it available: I created a symlink in a PATH-directoy but you can also create a symlink to pianoteq in your working directory. For simplified usage I named the symlink "pianoteq".

## Decide which pianoteq preset to use

Decide which preset you want to use. To get the correct naming use:
$ pianoteq --list-presets

## Install an id3-tag processor for setting MP3-Metadata

Install or make available a id3-processor. I found issueing "apropos id3" on the linux command line that mid3v2 is already installed on my fedora linux workstation, so I am using that (and integrating it into my conversion script).

## Get the Bash-Script doing all the work

Copy my conversion script from github (a single bash file) to your working directory:

* set the preset you want to use in the parameters

# Start with test data

To test and time the process, I moved all midi-xml-pairs into a subdir and only left 3 pairs in the working dir to try the process first on these before starting hours of conversion on my laptop.
