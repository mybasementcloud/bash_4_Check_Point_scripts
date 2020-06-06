
export file2find=alias_commands.add.all.sh
export findrootfolder=/home

FILEARRAY=()

GETFINDFILES=`find $findrootfolder -name $file2find`

arraylength=0
while read -r line; do

    if [ $arraylength -eq 0 ]; then
    	echo 'Files :  '
        echo
    fi

    FILEARRAY+=("$line")
	echo '['$arraylength'] '$line
	
	arraylength=${#FILEARRAY[@]}
	arrayelement=$((arraylength-1))
	
done <<< "$GETFINDFILES"

for j in "${FILEARRAY[@]}"
do
    #echo "$j : ${j//\'/}"
    echo $j
done


for i in "${FILEARRAY[@]}"
do
    
    # do something with $i from FILEARRAY
    
done