#!/bin/bash
#
# SCRIPT for BASH to generate a dump folder based on the current time and date and go there
#
ScriptVersion=00.01.00
ScriptDate=2018-05-22
#

export BASHScriptVersion=v00x01x00

#points to where jq is installed
#export JQ=${CPDIR}/jq/jq

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTSG=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

echo 'Date Time Group   :  '$DATE
echo 'Date (YYYY-MM-DD) :  '$DATEYMD
echo

# WAITTIME in seconds for read -t commands
export WAITTIME=60

export outputpathroot=/var/upgrade_export/dump
#export outputpathbase=$outputpathroot/$DATE
export outputpathbase=$outputpathroot/$DATEDTG
#export outputpathbase=$outputpathroot/$DATEYMD

if [ ! -r $outputpathroot ] 
then
    mkdir $outputpathroot
fi
if [ ! -r $outputpathbase ] 
then
    mkdir $outputpathbase
fi

echo 'Created folder :  '$outputpathbase
echo
ls -al $outputpathbase
echo

cd $outputpathbase
pwd
