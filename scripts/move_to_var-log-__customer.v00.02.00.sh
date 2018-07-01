#!/bin/bash
#
# SCRIPT Move current customer specifics from /var to /var/log/__customer
#
# (C) 2017-2018 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptVersion=00.02.00
ScriptDate=2018-06-30
#

export BASHScriptVersion=v00x02x00

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

echo 'Date Time Group   :  '$DATEDTGS
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


# =============================================================================
# =============================================================================
# START : Execute move of files from original location to new location
# =============================================================================

export logfile=/var/log/move_to_var-log-__customer.$ScriptVersion.$DATEDTGS.log

export pathsource=/var
#export pathtarget=/var/log/__customer
export pathtarget=$customerpathroot

echo | tee -a -i $logfile
echo 'Check for target path : '$pathtarget | tee -a -i $logfile
echo | tee -a -i $logfile
if [ ! -e $pathtarget ] ; then
    echo | tee -a -i $logfile
    echo 'Target path missing, make it! : '$pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    mkdir $pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'Set rights on target path : '$pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    ls -alhd $pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'chmod to 775' | tee -a -i $logfile
    chmod 775 $pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    ls -alhd $pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
else
    echo | tee -a -i $logfile
    echo 'Set rights on target path : '$pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    ls -alhd $pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'chmod to 775' | tee -a -i $logfile
    chmod 775 $pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
    ls -alhd $pathtarget | tee -a -i $logfile
    echo | tee -a -i $logfile
fi

export sourcefolder=cli_api_ops
if [ -e $pathsource/$sourcefolder ] ; then
    echo | tee -a -i $logfile
    echo 'Move source folder : '$pathsource/$sourcefolder' -to- '$pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    mv $pathsource/$sourcefolder $pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'Done!' | tee -a -i $logfile
    echo | tee -a -i $logfile
fi

export sourcefolder=cli_api_ops.wip
if [ -e $pathsource/$sourcefolder ] ; then
    echo | tee -a -i $logfile
    echo 'Move source folder : '$pathsource/$sourcefolder' -to- '$pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    mv $pathsource/$sourcefolder $pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'Done!' | tee -a -i $logfile
    echo | tee -a -i $logfile
fi

export sourcefolder=upgrade_export
if [ -e $pathsource/$sourcefolder ] ; then
    echo | tee -a -i $logfile
    echo 'Move source folder : '$pathsource/$sourcefolder' -to- '$pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    mv $pathsource/$sourcefolder $pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'Done!' | tee -a -i $logfile
    echo | tee -a -i $logfile
fi

export sourcefolder=download
if [ -e $pathsource/$sourcefolder ] ; then
    echo | tee -a -i $logfile
    echo 'Move source folder : '$pathsource/$sourcefolder' -to- '$pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    mv $pathsource/$sourcefolder $pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'Done!' | tee -a -i $logfile
    echo | tee -a -i $logfile
fi

export sourcefolder=downloads
if [ -e $pathsource/$sourcefolder ] ; then
    echo | tee -a -i $logfile
    echo 'Move source folder : '$pathsource/$sourcefolder' -to- '$pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    mv $pathsource/$sourcefolder $pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'Done!' | tee -a -i $logfile
    echo | tee -a -i $logfile
fi

export sourcefolder=ugex_exports
if [ -e $pathsource/$sourcefolder ] ; then
    echo | tee -a -i $logfile
    echo 'Move source folder : '$pathsource/$sourcefolder' -to- '$pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    mv $pathsource/$sourcefolder $pathtarget/ | tee -a -i $logfile
    echo | tee -a -i $logfile
    echo 'Done!' | tee -a -i $logfile
    echo | tee -a -i $logfile
fi

 
# =============================================================================
# END : Execute move of files from original location to new location
# =============================================================================
# =============================================================================

echo
echo 'logfile : '$logfile
echo

# =============================================================================
# =============================================================================
