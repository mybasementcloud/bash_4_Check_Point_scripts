#!/bin/bash
#
# SCRIPT for BASH to remove zero locks sessions by user WEB_API
#
ScriptVersion=00.02.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x02x00

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

deletefile=$outputpathbase/sessions_to_delete_uid.$DATEDTSG.csv
dumpfile=$outputpathbase/delete_session.$DATEDTSG.json

echo 'Before session delete'
echo
mgmt_cli -r true show sessions details-level full --format json | jq -r '.objects[] | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + (."expired-session"|tostring) + ", " + ."user-name")'

mgmt_cli -r true show sessions details-level full --format json | jq -r '.objects[] | select((."user-name"=="WEB_API")) | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + (."expired-session"|tostring) + ", " + ."user-name")' > $dumpfile
echo >> $dumpfile

echo 'uid' > $deletefile

mgmt_cli -r true show sessions limit 500 details-level full --format json | jq -r '.objects[] | select((.locks==0) and (.changes==0) and (."expired-session"==true) and (."user-name"=="WEB_API")) | [ .uid ] | @csv' >> $deletefile
#mgmt_cli -r true show sessions limit 500 details-level full --format json | jq -r '.objects[] | select(.locks==0) | [ .uid ] | @csv' >> $deletefile

mgmt_cli -r true discard --batch $deletefile >> $dumpfile

echo
echo 'After session delete'
echo
#mgmt_cli -r true show sessions details-level full --format json | jq -r '.objects[] | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + ."user-name")'
mgmt_cli -r true show sessions details-level full --format json | jq -r '.objects[] | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + (."expired-session"|tostring) + ", " + ."user-name")'

echo
ls -al $outputpathbase
echo

