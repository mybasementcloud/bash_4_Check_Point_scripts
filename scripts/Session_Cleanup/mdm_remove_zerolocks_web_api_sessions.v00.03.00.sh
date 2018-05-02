#!/bin/bash
#
# SCRIPT for BASH to remove zero locks sessions by user WEB_API on MDM
#
ScriptVersion=00.03.00
ScriptDate=2018-04-25
#

export BASHScriptVersion=v00x03x00

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

echo 'Management CLI Login'

export sessionfile=$outputpathbase/id.txt

#mgmt_cli login -r true --port 4434 domain 'System Data' > $sessionfile
mgmt_cli login -r true "$@" > $sessionfile
cat $sessionfile

echo 'Before session delete'
echo
mgmt_cli -r true -s $sessionfile show sessions details-level full --format json | jq -r '.objects[] | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + (."expired-session"|tostring) + ", " + ."user-name")'

mgmt_cli -r true -s $sessionfile show sessions details-level full --format json | jq -r '.objects[] | select((."user-name"=="WEB_API")) | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + (."expired-session"|tostring) + ", " + ."user-name")' > $dumpfile
echo >> $dumpfile

echo 'uid' > $deletefile

#mgmt_cli -r true -s $sessionfile show sessions limit 500 details-level full --format json | jq -r '.objects[] | select(.locks==0) | [ .uid ] | @csv' >> $deletefile
mgmt_cli -r true -s $sessionfile show sessions limit 500 details-level full --format json | jq -r '.objects[] | select((.locks==0) and (.changes==0) and (."expired-session"==true) and (."user-name"=="WEB_API")) | [ .uid ] | @csv' >> $deletefile

mgmt_cli -r true -s $sessionfile discard --batch $deletefile >> $dumpfile

echo
echo 'After session delete'
echo
#mgmt_cli -r true -s $sessionfile show sessions details-level full --format json | jq -r '.objects[] | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + ."user-name")'
mgmt_cli -r true -s $sessionfile show sessions details-level full --format json | jq -r '.objects[] | (.uid + ", " + (.locks|tostring) + ", " + (.changes|tostring) + ", " + (."expired-session"|tostring) + ", " + ."user-name")'

echo
echo 'Management CLI Logout and Clean-up'

mgmt_cli logout -s $sessionfile
rm $sessionfile

echo
ls -al $outputpathbase
echo

