importfile='somefile.txt'
resultfile='someotherfile.txt'
line=
touch $resultfile

COUNTER=0

while read -r line; do
    if [ $COUNTER -eq 0 ]; then
        # Line 0 first line we don't want to add a return yet
        echo -n 'Start:.'
    else
        # Lines 1+ are the data
        echo >> $resultfile
        echo -n '.'
    fi

    #Write the line, but not the carriage return
    echo -n "$line" >> $resultfile
    let COUNTER=COUNTER+1
done < $importfile

echo
echo

ls -alh $importfile
ls -alh $resultfile

cat $importfile

cat $resultfile


