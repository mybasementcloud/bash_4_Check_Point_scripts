#!/bin/bash
#
# Enable more informative logging of implied rules
#
ScriptVersion=00.01.00
ScriptDate=2018-03-29
#

export BASHScriptVersion=v00x01x00

export DATE=`date +%Y-%m-%d-%H%M%Z`
export workdir='./Change_Log/'$DATE'_Enable_Informative_Logging_Implied_Rules'

mkdir $workdir

#
# Set temporary value
#

echo
echo Check Value
echo
fw ctl get int fw_log_informative_implied_rules_enabled
echo
echo Set value to on
fw ctl set int fw_log_informative_implied_rules_enabled 1
echo
fw ctl get int fw_log_informative_implied_rules_enabled


#
# Set permanent value
#
echo
echo Set permanent value
echo

cp $FWDIR/boot/modules/fwkern.conf $FWDIR/boot/modules/fwkern.conf.original.$DATE
cp $FWDIR/boot/modules/fwkern.conf $workdir/fwkern.conf.original.$DATE
echo Original fwkern.conf
echo
cat $FWDIR/boot/modules/fwkern.conf

echo "fw_log_informative_implied_rules_enabled=1" >> $FWDIR/boot/modules/fwkern.conf
echo

cp $FWDIR/boot/modules/fwkern.conf $FWDIR/boot/modules/fwkern.conf.modified.$DATE
cp $FWDIR/boot/modules/fwkern.conf $workdir/fwkern.conf.modified.$DATE
cp $FWDIR/boot/modules/fwkern.conf $workdir/fwkern.conf

echo Modified fwkern.conf
echo
cat $FWDIR/boot/modules/fwkern.conf

echo
echo Working directory contents
echo Folder : $workdir
echo

ls -alh $workdir

