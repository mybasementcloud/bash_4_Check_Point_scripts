#!/bin/bash
#
# SCRIPT capture configuration values for bash and clish level 002
#
# (C) 2016-2018 Eric James Beasley
#
ScriptVersion=00.07.01
ScriptDate=2018-01-21
#

export BASHScriptVersion=v00x07x01


echo
echo 'Script Configuration Capture script version '$ScriptVersion' from '$ScriptDate
echo

#----------------------------------------------------------------------------------------
# Setup Basic Parameters
#----------------------------------------------------------------------------------------

#points to where jq is installed
#export JQ=${CPDIR}/jq/jq

export DATE=`date +%Y-%m-%d-%H%M%S%Z`

echo 'Date Time Group   :  '$DATE
echo

export localdotpath=`echo $PWD`

export currentlocalpath=$localdotpath
export workingpath=$currentlocalpath

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# Gaia version and installation type identification
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


export gaiaversion=$(clish -c "show version product" | cut -d " " -f 6)
echo 'Gaia Version : $gaiaversion = '$gaiaversion
echo

Check4SMS=0
Check4EPM=0
Check4MDS=0
Check4GW=0

workfile=/var/tmp/cpinfo_ver.txt
cpinfo -y all > $workfile 2>&1
Check4EP773003=`grep -c "Endpoint Security Management R77.30.03 " $workfile`
Check4EP773002=`grep -c "Endpoint Security Management R77.30.02 " $workfile`
Check4EP773001=`grep -c "Endpoint Security Management R77.30.01 " $workfile`
Check4EP773000=`grep -c "Endpoint Security Management R77.30 " $workfile`
Check4EP=`grep -c "Endpoint Security Management" $workfile`
Check4SMS=`grep -c "Security Management Server" $workfile`
rm $workfile

if [ "$MDSDIR" != '' ]; then
    Check4MDS=1
else 
    Check4MDS=0
fi

if [ $Check4SMS -gt 0 ] && [ $Check4MDS -gt 0 ]; then
    echo "System is Multi-Domain Management Server!"
    Check4GW=0
elif [ $Check4SMS -gt 0 ] && [ $Check4MDS -eq 0 ]; then
    echo "System is Security Management Server!"
    Check4SMS=1
    Check4GW=0
else
    echo "System is a gateway!"
    Check4GW=1
fi
echo

if [ $Check4EP773000 -gt 0 ] && [ $Check4EP773003 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.03"
    export gaiaversion=R77.30.03
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773002 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.02"
    export gaiaversion=R77.30.02
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ] && [ $Check4EP773001 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30.01"
    export gaiaversion=R77.30.01
    Check4EPM=1
elif [ $Check4EP773000 -gt 0 ]; then
    echo "Endpoint Security Server version R77.30"
    export gaiaversion=R77.30
    Check4EPM=1
else
    echo "Not Gaia Endpoint Security Server"
    Check4EPM=0
fi

echo
echo 'Final $gaiaversion = '$gaiaversion
echo


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# base parameters
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------



#export outputpathroot=/var/upgrade_export
export outputpathroot=./host_data
#export outputpathroot=`realpath "$outputpathroot"`
export expandedpath=$(cd $outputpathroot ; pwd)
export outputpathroot=${expandedpath}
#echo 'outputpathroot = '$outputpathroot

export outputpathbase=$outputpathroot
export outputpathbase=$outputpathroot/$DATE

#export outputhomepath=$outputpathbase/home
export outputhomepath=$outputpathbase


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# shell meat
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------


#----------------------------------------------------------------------------------------
# Configure specific parameters
#----------------------------------------------------------------------------------------

export targetversion=$gaiaversion

export outputfilepath=$outputpathbase/
export outputfileprefix=$HOSTNAME'_'$targetversion
export outputfilesuffix='_'$DATE
export outputfiletype=.txt

if [ ! -r $outputpathroot ] ; then
    mkdir $outputpathroot
    chmod 775 $outputpathroot
else
    chmod 775 $outputpathroot
fi
if [ ! -r $outputpathbase ] ; then
    mkdir $outputpathbase
    chmod 775 $outputpathbase
else
    chmod 775 $outputpathbase
fi
if [ ! -r $outputfilepath ] ; then
    mkdir $outputfilepath
    chmod 775 $outputfilepath
else
    chmod 775 $outputfilepath
fi

if [ ! -r $outputhomepath ] ; then
    mkdir $outputhomepath
    chmod 775 $outputhomepath
else
    chmod 775 $outputhomepath
fi

#----------------------------------------------------------------------------------------
# bash - backup user's home folder
#----------------------------------------------------------------------------------------

export homebackuproot=.
#export homebackuproot=`realpath "$homebackuproot"`
export expandedpath=$(cd $homebackuproot ; pwd)
export homebackuproot=${expandedpath}
export homebackuppath="$homebackuproot/home.backup"

if [ ! -r $homebackuppath ] ; then
    mkdir $homebackuppath
    chmod 775 $homebackuppath
else
    chmod 775 $homebackuppath
fi

export command2run=backup-home
export outputfile=$command2run'_'$outputfileprefix$outputfilesuffix'.txt'
export outputfilefqdn=$outputfilepath$outputfile
touch "$outputfilefqdn"

echo
echo 'Execute '$command2run' to '$outputhomepath' with ouptut to : '$outputfilefqdn

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo "Copy /home folder to $outputhomepath" >> "$outputfilefqdn"
cp -a -v "/home/" "$outputhomepath" >> "$outputfilefqdn"

echo
echo 'Execute '$command2run' to '$homebackuppath' with ouptut to : '$outputfilefqdn
echo >> "$outputfilefqdn"

pushd /home

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo "Copy /home folder contents to $homebackuppath" >> "$outputfilefqdn"
cp -a -v "." "$homebackuppath" >> "$outputfilefqdn"

popd

echo >> "$outputfilefqdn"
echo "Current path : " >> "$outputfilefqdn"
pwd >> "$outputfilefqdn"

echo >> "$outputfilefqdn"

echo "Current path : "
pwd


#----------------------------------------------------------------------------------------
# clish - save configuration to file
#----------------------------------------------------------------------------------------

export command2run=config
export outputfile=$command2run'_'$outputfileprefix$outputfilesuffix
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
clish -c "lock database override"
clish -c "save config"
clish -c "save configuration $outputfile"
clish -c "save config"
cp $outputfile $outputfilefqdn


#----------------------------------------------------------------------------------------
# clish and bash - Gather version information from all possible methods
#----------------------------------------------------------------------------------------

export command2run=versions
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

touch $outputfilefqdn
echo 'Versions:' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo 'clish : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
clish -c "show version all" >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'cpinfo -y all : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
cpinfo -y all >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'fwm ver : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
fwm ver >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'fw ver : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
fw ver >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'installed_jumbo_take : ' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
installed_jumbo_take >> "$outputfilefqdn"
echo >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather licensing information
#----------------------------------------------------------------------------------------

export command2run=cplic
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
cplic print > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - basic information
#----------------------------------------------------------------------------------------

export command2run=basic_information
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn

touch $outputfilefqdn
echo >> "$outputfilefqdn"
echo 'Memory Utilization : free -m -t' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

free -m -t >> "$outputfilefqdn"

echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo 'Disk Utilization : df -h' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"

df -h >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather route details
#----------------------------------------------------------------------------------------

export command2run=route
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
route -vn > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather arp details
#----------------------------------------------------------------------------------------

export command2run=arp
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn

touch $outputfilefqdn
arp -vn >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
echo >> "$outputfilefqdn"
arp -av >> "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface details
#----------------------------------------------------------------------------------------

export command2run=ifconfig
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
ifconfig > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - gather interface name rules
#----------------------------------------------------------------------------------------

export command2run=interface-naming-rules
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile
export file2copy=00-OS-XX.rules
export file2copypath="/etc/udev/rules.d/$file2copy"

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
cat "$file2copypath" > "$outputfilefqdn"
cp "$file2copypath" "$outputfilepath"


#----------------------------------------------------------------------------------------
# bash - generate device and system information via dmidecode
#----------------------------------------------------------------------------------------

export command2run=dmidecode
export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
export outputfilefqdn=$outputfilepath$outputfile

echo
echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
dmidecode > "$outputfilefqdn"


#----------------------------------------------------------------------------------------
# bash - collect $FWDIR/boot/modules/fwkern.conf and backup if it exists
#----------------------------------------------------------------------------------------

# $FWDIR/boot/modules/fwkern.conf
export file2copy=fwkern.conf
export file2copypath="$FWDIR/boot/modules/$file2copy"
export outputfile=$outputfileprefix'_'$file2copy$outputfilesuffix
export outputfilefqdn=$outputfilepath$outputfile

if [ ! -r $file2copypath ] ; then
    echo
    echo 'No fwkern.conf file at :  '$file2copypath
else
    echo
    echo 'copy '$file2copy' to : '"$outputfilefqdn"
    cp "$file2copypath" "$outputfilefqdn"
    cp "$file2copypath" "$outputfilepath"
    cp "$file2copypath" .
fi
echo


#----------------------------------------------------------------------------------------
# bash - GW - status of SecureXL
#----------------------------------------------------------------------------------------

if [ $Check4GW -eq 1 ]; then
    
    export command2run=fwaccel-statistics
    export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
    export outputfilefqdn=$outputfilepath$outputfile
    
    echo
    echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
    
    touch $outputfilefqdn
    echo >> "$outputfilefqdn"
    echo 'fwacell stat' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stat >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwacell stats' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stats >> "$outputfilefqdn"
    
    echo >> "$outputfilefqdn"
    echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    echo 'fwacell stats -s' >> "$outputfilefqdn"
    echo >> "$outputfilefqdn"
    
    fwaccel stats -s >> "$outputfilefqdn"
    
fi


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#

#----------------------------------------------------------------------------------------
# bash - ?what next?
#----------------------------------------------------------------------------------------

#export command2run=command
#export outputfile=$outputfileprefix'_'$command2run$outputfilesuffix$outputfiletype
#export outputfilefqdn=$outputfilepath$outputfile

#echo
#echo 'Execute '$command2run' with ouptut to : '$outputfilefqdn
#command > "$outputfilefqdn"

#echo '----------------------------------------------------------------------------' >> "$outputfilefqdn"
#echo >> "$outputfilefqdn"
#echo 'fwacell stats -s' >> "$outputfilefqdn"
#echo >> "$outputfilefqdn"
#
#fwaccel stats -s >> "$outputfilefqdn"
#


#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# end shell meat
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------



echo 'CLI Operations Completed'

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
#
# shell clean-up and log dump
#
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

echo
ls -alh $outputpathroot
#ls -alhR $outputpathroot
echo
#echo
#ls -alhR $outputpathbase
#echo

#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------
# End of Script
#----------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------

