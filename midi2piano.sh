#!/bin/bash
# (c) ITTB, converts welt-mignon midi-files to mp3 using pianoteq. ID3-tags and file naming based on xml-metadata
# ATTENTION: this script is not optimized for robustness, it will
# NOT check if any operation fails
# NOT verify if files exist
# NOT check if files are overwritten
# ... it's simple linear code ....


# global definitions
LOGFILE="midi2piano.log"
PRESET="My Presets/SteinwayWelte"
# Metadata IDs: the following associative array holds the XML-IDs of the various metadata fields
declare -A Metaidx
# Fields for Metadata-Structure: store in enumeration
declare -a Fields
Fields=("song" "artist" "release" "composer")
# Metaidx stores the index values of the xml-fields containing the metadata
# if this does not fit your needs, you may change the "idx" to select the desired values from xml. Format is: "tag,code"
Metaidx[song]="245 a"
Metaidx[artist]="511 a"
Metaidx[composer]="100 a"
Metaidx[release]="264 c"

declare -A Metadata
Metadata[song]=""
Metadata[artist]=""
Metadata[composer]=""
Metadata[release]=""
Metadata[genre]="classical"


# ===================== function scanfiles ======================================
# for each marcxml-file
# * parse for parameters,
# * converts midi to mp3
# * set filename according to

scanfiles () {
  for d in *.marcxml; do
# get basename without extension
   logtext "Processing $d"
   OUTFILE=$(basename "$d" | cut -d. -f1)
   logtext "Basename is $OUTFILE"

# get metadata: loop over Metaidx to get the metadata-values from the xml
   for idx in ${Fields[@]}; do
#      get index for xml-parsint into selector
       selector=${Metaidx[$idx]}
#      split selector into tag/code
       set -- $selector
       tag=$1
       code=$2
       logtext "for $idx we use tag=$1 and code=$2"
# now get metadata from xml
       XPATH="//datafield[@tag='$tag']/subfield[@code='$code']"
       logtext "xpath-variable $XPATH, writing to $idx"
       Metadata[$idx]=$(xidel --xpath="//datafield[@tag='$tag']/subfield[@code='$code']" $OUTFILE.marcxml)
   done
# now the array Metadata is filled with all the metadata we need: write it to the logfile:
   logtext "File $OUTFILE.marcxml has the following metadata"
   for idx in ${Fields[@]}; do
       to_printable "${Metadata[$idx]}"
       Metadata[$idx]="$RETURN"
       logtext "$idx is ${Metadata[$idx]}"
   done

# remove square brackets from "release"
   Metadata[release]=$(echo ${Metadata[release]} | sed 's/[^0-9]*//g')
   logtext "release is now ${Metadata[release]}"

# now convert midi to mp3 (temporary filename)
   logtext "setting filename from _exp-midi files (adding _exp!)"
   midifile="$OUTFILE""_exp.mid"
   logtext "converting $midifile to mp3"
   time pianoteq --headless --midi $midifile --mp3 $OUTFILE.mp3 --preset "$PRESET"
   logtext "conversion done!"
   filename="${Metadata[composer]} ${Metadata[song]} ${Metadata[artist]} ${Metadata[release]}.mp3"
   logtext "target filename: $filename"
   mv "$OUTFILE.mp3" "$filename"

# set id3 attributes of outfile
   mid3v2 --song "${Metadata[song]}" "$filename"
   mid3v2 --TCOM "${Metadata[composer]}" "$filename"
   mid3v2 --TDAT "${Metadata[release]}" "$filename"
   mid3v2 --artist "${Metadata[artist]}" "$filename"
   mid3v2 --genre "classical" "$filename"


done
}

# ====================== to_printable =====================
function to_printable {
# return value is written to global RETURN

# do charset-converion
RETURN=$(echo $1 | iconv -f UTF-8 -t ASCII//TRANSLIT)

# remove remaining not printable characters
RETURN=$(echo $RETURN | sed 's/[^[:print:]]/ /g;')

# remove other non convenient characters
RETURN=$(echo "$RETURN" | sed "s/[\"\'\`\\\:\/\,\.]//g")
}


# ===================== function logtext ======================================
# Parameter: text to write to logfile
# function for writing text to logfile
logtext () {
   echo "`date`: " $1 2>&1 | tee -a $LOGFILE
}   

# ============================ MAIN ================================

STARTDIR=$(pwd)
logtext "Working dir: $STARTDIR"
logtext  "==================  Starting==================  "
cd $STARTDIR
logtext "starting at dir: $STARTDIR"
scanfiles

exit 0

# End of Main


# EOF
