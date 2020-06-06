#----------------------------------------------------------------------------------------
# Configure specific parameters
#----------------------------------------------------------------------------------------

export targetversion=$gaiaversion

export outputfilepath=$outputpathbase/
export outputfileprefix=$HOSTNAME'_'$targetversion
export outputfilesuffix='_'$DATEDTGS
export outputfiletype=.txt

if [ ! -r $outputfilepath ] ; then
    mkdir $outputfilepath
    chmod 775 $outputfilepath
else
    chmod 775 $outputfilepath
fi


#----------------------------------------------------------------------------------------
# bash - Collect Interface Information per interface
#----------------------------------------------------------------------------------------

export command2run=show_interfaces
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

cat $logfilepath > $outputfilefqdn
echo | tee -a -i $outputfilefqdn
rm $logfilepath

echo 'Executing commands for '$command2run' with output to file : '$outputfilefqdn | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

clish -c "show interfaces" | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

IFARRAY=()

GETINTERFACES="`clish -c "show interfaces"`"

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn
echo 'Build array of interfaces : ' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

arraylength=0
while read -r line; do

    if [ $arraylength -eq 0 ]; then
    	echo -n 'Interfaces :  ' | tee -a -i $outputfilefqdn
    else
    	echo -n ', ' | tee -a -i $outputfilefqdn
    fi

    #IFARRAY+=("$line")
    if [ "$line" == 'lo' ]; then
        echo -n 'Not adding '$line | tee -a -i $outputfilefqdn
    else 
        IFARRAY+=("$line")
    	echo -n $line | tee -a -i $outputfilefqdn
    fi
	
	arraylength=${#IFARRAY[@]}
	arrayelement=$((arraylength-1))
	
done <<< "$GETINTERFACES"

echo | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

echo 'Identified Interfaces in array for detail data collection :' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn

for j in "${IFARRAY[@]}"
do
    #echo "$j, ${j//\'/}"  | tee -a -i $outputfilefqdn
    echo $j | tee -a -i $outputfilefqdn
done
echo | tee -a -i $outputfilefqdn

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


for i in "${IFARRAY[@]}"
do
    
    export interfaceoutputfile=$outputfileprefix'_'$command2run'_'$i'_'$outputfilesuffix$outputfiletype
    export interfaceoutputfilefqdn=$outputfilepath$interfaceoutputfile
    
    echo 'Executing commands for interface : '$i' with output to file : '$interfaceoutputfilefqdn | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn
    
    ifconfig $i | tee -a -i $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -i '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -i $i >> $interfaceoutputfilefqdn

    echo | tee -a -i $outputfilefqdn
    cat $interfaceoutputfilefqdn | grep bus | tee -a -i $outputfilefqdn
    echo | tee -a -i $outputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -g '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -g $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -k '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -k $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    echo 'Execute ethtool -S '$i >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn

    ethtool -S $i >> $interfaceoutputfilefqdn

    echo >> $interfaceoutputfilefqdn
    echo '----------------------------------------------------------------------------------------' >> $interfaceoutputfilefqdn
    echo >> $interfaceoutputfilefqdn
    
    cat $interfaceoutputfilefqdn >> $outputfilefqdn
    echo >> $outputfilefqdn

    echo >> $outputfilefqdn
    echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
    echo >> $outputfilefqdn

    
done

echo | tee -a -i $outputfilefqdn
echo '----------------------------------------------------------------------------------------' | tee -a -i $outputfilefqdn
echo | tee -a -i $outputfilefqdn


