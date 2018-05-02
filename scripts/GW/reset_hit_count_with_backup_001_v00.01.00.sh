#!/bin/bash
#
# Gateway - Reset Hit Count to zero, backing up current
#
ScriptVersion=00.01.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x01x00


export DATE=`date +%Y-%m-%d-%H%M%S%Z`

export logroot=/var/upgrade_export
export logpath=$logroot/Change_Log
export logfile=$logpath/reset_hit_count.$HOSTNAME.$DATE.txt

export workfilepath=$CPDIR/database/cpeps
export bufilepath=$workfilepath/BACKUP.$DATE

touch $logfile
echo >> $logfile
echo 'Start operation to reset hit count on '$HOSTNAME' at '$DATE >> $logfile
echo >> $logfile

cd $workfilepath/ >> $logfile
echo >> $logfile

mkdir $bufilepath >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Stop gateway services again' >> $logfile
echo 'Stop gateway services again'
echo >> $logfile

cpstop > $logfile
echo >> $logfile

echo >> $logfile
echo 'Backup hit count files to '$bufilepath >> $logfile
echo 'Backup hit count files to '$bufilepath
echo >> $logfile
echo

cp *1.3.6.1.4.1.2620.1.45.5* $bufilepath/ >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Remove hit count files' >> $logfile
echo 'Remove hit count files'
echo >> $logfile
echo

rm *1.3.6.1.4.1.2620.1.45.5* >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Start gateway services again' >> $logfile
echo 'Start gateway services again'
echo >> $logfile

cpstart >> $logfile
echo >> $logfile

echo >> $logfile
echo 'Finished operation to reset hit count on '$HOSTNAME' at '$DATE >> $logfile
echo >> $logfile

cd %logroot
