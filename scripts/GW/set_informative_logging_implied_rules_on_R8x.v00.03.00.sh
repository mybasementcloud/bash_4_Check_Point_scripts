#!/bin/bash
#
# Enable more informative logging of implied rules
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.03.00
ScriptDate=2018-06-30
#

export BASHScriptVersion=v00x03x00

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Basic Configuration
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# Date variable configuration
# -------------------------------------------------------------------------------------------------

export DATE=`date +%Y-%m-%d-%H%M%Z`
export DATEDTG=`date +%Y-%m-%d-%H%M%Z`
export DATEDTGS=`date +%Y-%m-%d-%H%M%S%Z`
export DATEYMD=`date +%Y-%m-%d`

echo 'Date Time Group   :  '$DATE $DATEDTG $DATEDTGS
echo 'Date (YYYY-MM-DD) :  '$DATEYMD
echo
    

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# JQ and json related
# -------------------------------------------------------------------------------------------------

# points to where jq is installed
export JQ=${CPDIR}/jq/jq
    
# -------------------------------------------------------------------------------------------------
# END:  Basic Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------
# START: Root Script Configuration
# -------------------------------------------------------------------------------------------------

export scriptspathroot=/var/log/__customer/upgrade_export/scripts
export rootscriptconfigfile=__root_script_config.sh


# -------------------------------------------------------------------------------------------------
# localrootscriptconfiguration - Local Root Script Configuration setup
# -------------------------------------------------------------------------------------------------

localrootscriptconfiguration () {
    #
    # Local Root Script Configuration setup
    #

    # WAITTIME in seconds for read -t commands
    export WAITTIME=60
    
    export customerpathroot=/var/log/__customer
    export customerworkpathroot=$customerpathroot/upgrade_export
    export outputpathroot=$customerworkpathroot/dump
    export changelogpathroot=$customerworkpathroot/Change_Log
    
    echo
    return 0
}


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

if [ -r "$scriptspathroot/$rootscriptconfigfile" ] ; then
    # Found the Root Script Configuration File in the folder for scripts
    # So let's call that script to configure what we need

    . $scriptspathroot/$rootscriptconfigfile "$@"
    errorreturn=$?
elif [ -r "../$rootscriptconfigfile" ] ; then
    # Found the Root Script Configuration File in the folder above the executiong script
    # So let's call that script to configure what we need

    . ../$rootscriptconfigfile "$@"
    errorreturn=$?
elif [ -r "$rootscriptconfigfile" ] ; then
    # Found the Root Script Configuration File in the folder with the executiong script
    # So let's call that script to configure what we need

    . $rootscriptconfigfile "$@"
    errorreturn=$?
else
    # Did not the Root Script Configuration File
    # So let's call local configuration

    localrootscriptconfiguration "$@"
    errorreturn=$?
fi


# -------------------------------------------------------------------------------------------------
# END:  Root Script Configuration
# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


if [ ! -r $customerworkpathroot ]; then
    mkdir $customerworkpathroot
fi
if [ ! -r $changelogpathroot ]; then
    mkdir $changelogpathroot
fi

export workdir=$changelogpathroot/$DATEDTGS'_Enable_Informative_Logging_Implied_Rules'

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

cp $FWDIR/boot/modules/fwkern.conf $FWDIR/boot/modules/fwkern.conf.original.$DATEDTGS
cp $FWDIR/boot/modules/fwkern.conf $workdir/fwkern.conf.original.$DATEDTGS
echo Original fwkern.conf
echo
cat $FWDIR/boot/modules/fwkern.conf

echo "fw_log_informative_implied_rules_enabled=1" >> $FWDIR/boot/modules/fwkern.conf
echo

cp $FWDIR/boot/modules/fwkern.conf $FWDIR/boot/modules/fwkern.conf.modified.$DATEDTGS
cp $FWDIR/boot/modules/fwkern.conf $workdir/fwkern.conf.modified.$DATEDTGS
cp $FWDIR/boot/modules/fwkern.conf $workdir/fwkern.conf

echo Modified fwkern.conf
echo
cat $FWDIR/boot/modules/fwkern.conf

echo
echo Working directory contents
echo Folder : $workdir
echo

ls -alh $workdir

