#!/bin/bash
#
# SCRIPT Template for CLI Operations for command line parameters handling
#
# (C) 2016-2020 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
#
SubScriptDate=2020-10-26
SubScriptVersion=04.20.00
SubScriptRevision=000
TemplateVersion=04.41.00
TemplateLevel=006
SubScriptsLevel=006
SubScriptsVersion=04.20.00
SubScriptTemplateVersion=04.20.00
#

BASHActualSubScriptVersion=v${SubScriptVersion//./x}

BASHSubScriptsVersion=v${SubScriptsVersion//./x}
BASHSubScriptsRevision=v${SubScriptRevision//./x}

#export BASHExpectedSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion//./x}
BASHActualSubScriptsVersion=${SubScriptsLevel}.v${SubScriptsVersion//./x}

BASHSubScriptsTemplateVersion=v${SubScriptTemplateVersion//./x}
BASHSubScriptsTemplateLevel=${TemplateLevel}.v${SubScriptTemplateVersion}

BASHSubScriptScriptTemplateVersion=v${TemplateVersion//./x}
BASHSubScriptScriptTemplateLevel=${TemplateLevel}.v${TemplateVersion}


SubScriptFileNameRoot=_template_sub_scripts
SubScriptShortName="_template_sub_scripts.$SubScriptsLevel"
SubScriptDescription="Sub Scripts Template"

#SubScriptName=$SubScriptFileNameRoot.subscript.$SubScriptsLevel.v$SubScriptVersion
SubScriptName=$SubScriptFileNameRoot.subscript.$SubScriptsLevel.v$SubScriptVersion

SubScriptHelpFileName=${SubScriptFileNameRoot}.help
SubScriptHelpFilePath=help.v${SubScriptVersion}
SubScriptHelpFile=${SubScriptHelpFilePath}/${SubScriptHelpFileName}


# =================================================================================================
# Validate Sub-Script template version is correct for caller
# =================================================================================================


if [ x"$BASHExpectedSubScriptsVersion" = x"$BASHActualSubScriptsVersion" ] ; then
    # Script and Actions Script versions match, go ahead
    echo >> $logfilepath
    echo 'Verify Actions Scripts Version - OK' >> $logfilepath
    echo >> $logfilepath
else
    # Script and Actions Script versions don't match, ALL STOP!
    echo | tee -a -i $logfilepath
    echo 'Verify Actions Scripts Version - Missmatch' | tee -a -i $logfilepath
    echo 'Expected Subscript version : '$BASHExpectedSubScriptsVersion | tee -a -i $logfilepath
    echo 'Current  Subscript version : '$BASHActualSubScriptsVersion | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo 'Critical Error - Exiting Script !!!!' | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath
    echo "Log output in file $logfilepath" | tee -a -i $logfilepath
    echo | tee -a -i $logfilepath

    exit 250
fi


# =================================================================================================
# =================================================================================================
# START sub script:  template sub script
# =================================================================================================


echo >> $logfilepath
echo 'Subscript Name:  '$SubScriptName'  Subcript Version: '$SubScriptVersion'  Subscript Revision:  '$SubScriptRevision'  Level:  '$SubScriptsLevel'  Template Version: '$TemplateVersion >> $logfilepath
echo >> $logfilepath


# -------------------------------------------------------------------------------------------------
# Handle important basics
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# START:  Local Proceedures - Handle important basics
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Something important
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# =================================================================================================
# END:  Local Proceedures - Handle important basics
# =================================================================================================


# =================================================================================================
# =================================================================================================
# START:  _template sub script
# =================================================================================================


# -------------------------------------------------------------------------------------------------
# Something
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------------------

# =================================================================================================
# END:  _template sub script
# =================================================================================================
# =================================================================================================

return 0


# =================================================================================================
# END:  
# =================================================================================================
# =================================================================================================


