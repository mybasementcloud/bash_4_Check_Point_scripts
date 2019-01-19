#!/bin/bash
#
# SCRIPT Template for bash scripts, level - 006
#
# (C) 2016-2019 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
ScriptDate=2019-01-18
ScriptVersion=03.00.00
ScriptRevision=001
TemplateLevel=006
TemplateVersion=03.00.00
#

export BASHScriptVersion=v${ScriptVersion//./x}
export BASHScriptTemplateVersion=v${TemplateVersion//./x}

export BASHScriptName=_template_bash_scripts_light.$TemplateLevel.v$ScriptVersion
export BASHScriptShortName=_template_light.$TemplateLevel.v$ScriptVersion
export BASHScriptDescription="Template Light for bash scripts"


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
# Other variable configuration
# -------------------------------------------------------------------------------------------------


WAITTIME=20


# -------------------------------------------------------------------------------------------------
# Script Operations
# -------------------------------------------------------------------------------------------------


# do something


# -------------------------------------------------------------------------------------------------
# End of script
# -------------------------------------------------------------------------------------------------

echo 'Done!'
echo
