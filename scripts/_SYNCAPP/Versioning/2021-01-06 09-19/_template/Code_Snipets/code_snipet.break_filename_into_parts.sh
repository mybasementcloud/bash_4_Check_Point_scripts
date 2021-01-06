#!/bin/bash
#

export fullfile=$1
export filepath=$(dirname "$fullfile")
export file=$(basename -- "$fullfile")
export filename1="${file%.*}"
export fileext1="${file##*.}"
export filename2="${fullfile##*/}"
export fileext2="${fullfile##*.}"

echo 'Parameter : "'$1'"'
echo
echo 'Fullfile   : $1                          : "'$fullfile'"'
echo 'filepath   : $(dirname "$fullfile")      : "'$filepath'"'
echo
echo 'File       : $(basename -- "$fullfile")  : "'$file'"'
echo 'filename1  : "${file%.*}"                : "'$filename1'"'
echo 'Extension1 : "${file##*.}"               : "'$fileext1'"'
echo
echo 'filename2  : "${fullfile##*/}"           : "'$filename2'"'
echo 'Extension2 : "${fullfile##*.}"           : "'$fileext2'"'
echo


echo
echo 'Alternative method (multiple parameters possible):'
echo

for fullpath in "$@" ; do
    filename="${fullpath##*/}"                      # Strip longest match of */ from start
    dir="${fullpath:0:${#fullpath} - ${#filename}}" # Substring from 0 thru pos of filename
    base="${filename%.[^.]*}"                       # Strip shortest match of . plus at least one non-dot char from end
    ext="${filename:${#base} + 1}"                  # Substring from len of base thru end
    if [[ -z "$base" && -n "$ext" ]]; then          # If we have an extension and no base, it's really the base
        base=".$ext"
        ext=""
    fi

    echo -e "$fullpath:\n\tdir  = \"$dir\"\n\tbase = \"$base\"\n\text  = \"$ext\""
done

echo
echo
