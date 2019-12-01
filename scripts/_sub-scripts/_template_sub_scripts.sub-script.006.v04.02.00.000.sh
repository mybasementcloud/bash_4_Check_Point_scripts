#!/bin/bash
#
# SCRIPT Template for CLI Operations for command line parameters handling
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
SubScriptDate=2019-11-22
SubScriptVersion=04.02.00
SubScriptRevision=000
SubScriptsLevel=006
TemplateVersion=04.15.00
TemplateLevel=006
#

BASHScriptTemplateVersion=v${TemplateVersion//./x}
BASHScriptTemplateLevel=$TemplateLevel.v$TemplateVersion

BASHSubScriptVersion=v${SubScriptVersion//./x}
SubScriptsVersion=$SubScriptsLevel.v${SubScriptVersion//./x}

SubScriptFileNameRoot=_template_sub_scripts
SubScriptShortName="_template_sub_scripts.$SubScriptsLevel"
SubScriptDescription="Sub Scripts Template"

#SubScriptName=$SubScriptFileNameRoot.sub-script.$SubScriptsLevel.v$SubScriptVersion
SubScriptName=$SubScriptFileNameRoot.sub-script.$SubScriptsLevel.v$SubScriptVersion

SubScriptHelpFileName="$SubScriptFileNameRoot.help"
SubScriptHelpFilePath="help.v$SubScriptVersion"
SubScriptHelpFile="$SubScriptHelpFilePath/$SubScriptHelpFileName"


# =================================================================================================
# Validate Sub-Script template version is correct for caller
# =================================================================================================


if [ x"$BASHExpectedSubScriptsVersion" = x"$SubScriptsVersion" ] ; then
    # Script and Actions Script versions match, go ahead
    echo >> $logfilepath
    echo 'Verify Actions Scripts Version - OK' >> $logfilepath
    echo >> $logfilepath
else
    # Script and Actions Script versions don't match, ALL STOP!
    echo | tee -a -i $logfilepath
    echo 'Verify Actions Scripts Version - Missmatch' | tee -a -i $logfilepath
    echo 'Expected Subscript version : '$BASHExpectedSubScriptsVersion | tee -a -i $logfilepath
    echo 'Current  Subscript version : '$SubScriptsVersion | tee -a -i $logfilepath
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
echo 'Subscript Name:  '$SubScriptName'  Subcript Version: '$SubScriptVersion'  Level:  '$SubScriptsLevel'  Revision:  '$SubScriptRevision'  Template Version: '$TemplateVersion >> $logfilepath
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


