#!/bin/bash
#
# SCRIPT test stuff for config
#
# (C) 2016-2018 Eric James Beasley
#
ScriptVersion=00.09.00
ScriptDate=2018-05-25
#

export BASHScriptVersion=v00x09x00

export notthispath=/home/
export startpathroot=.
export alternatepathroot=/var/tmp

export expandedpath=$(cd $startpathroot ; pwd)
export startpathroot=$expandedpath
export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
export isitthispath=`test -z $checkthispath; echo $?`

if [ $isitthispath -eq 1 ] ; then
    #Oh, Oh, we're in the home directory executing, not good!!!
    #Configure outputpathroot for $alternatepathroot folder since we can't run in /home/
    echo 'looks like we are in home path'
    export outputpathroot=$alternatepathroot
else
    #OK use the current folder and create host_data sub-folder
    echo 'NOT in home path'
    export outputpathroot=$startpathroot
fi

echo '1 expandedpath   = '\"$expandedpath\"
echo '1 checkthispath  = '\"$checkthispath\"
echo '1 isitthispath   = '\"$isitthispath\"
echo '1 outputpathroot = '\"$outputpathroot\"
echo

if [ ! -r $outputpathroot ] ; then
    #not where we're expecting to be, since $outputpathroot is missing here
    #OK, so make the expected folder and set permissions we need
    mkdir $outputpathroot
    chmod 775 $outputpathroot
else
    #set permissions we need
    chmod 775 $outputpathroot
fi

#Now that outputroot is not in /home/ let's work on where we are working from

export expandedpath=$(cd $outputpathroot ; pwd)
export checkthispath=`echo "${expandedpath}" | grep -i "$notthispath"`
export isitthispath=`test -z $checkthispath; echo $?`
export outputpathroot=${expandedpath}

echo '2 expandedpath   = '\"$expandedpath\"
echo '2 checkthispath  = '\"$checkthispath\"
echo '2 isitthispath   = '\"$isitthispath\"
echo '2 outputpathroot = '\"$outputpathroot\"
echo

echo
export gaia_kernel_version=$(uname -r)
export kernelv2x06=2.6
export kernelv3x10=3.10
export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv2x06"`
export isitoldkernel=`test -z $checkthiskernel; echo $?`
export checkthiskernel=`echo "${gaia_kernel_version}" | grep -i "$kernelv3x10"`
export isitnewkernel=`test -z $checkthiskernel; echo $?`

if [ $isitoldkernel -eq 1 ] ; then
    echo "OLD Kernel version $gaia_kernel_version"
elif [ $isitnewkernel -eq 1 ]; then
    echo "NEW Kernel version $gaia_kernel_version"
else
    echo "Kernel version $gaia_kernel_version"
fi
echo

