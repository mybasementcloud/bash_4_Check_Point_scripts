#!/bin/bash
#
# (C) 2016-2022 Eric James Beasley, @mybasementcloud, https://github.com/mybasementcloud/bash_4_Check_Point_scripts
#
# ALL SCRIPTS ARE PROVIDED AS IS WITHOUT EXPRESS OR IMPLIED WARRANTY OF FUNCTION OR POTENTIAL FOR 
# DAMAGE Or ABUSE.  AUTHOR DOES NOT ACCEPT ANY RESPONSIBILITY FOR THE USE OF THESE SCRIPTS OR THE 
# RESULTS OF USING THESE SCRIPTS.  USING THESE SCRIPTS STIPULATES A CLEAR UNDERSTANDING OF RESPECTIVE
# TECHNOLOGIES AND UNDERLYING PROGRAMMING CONCEPTS AND STRUCTURES AND IMPLIES CORRECT IMPLEMENTATION
# OF RESPECTIVE BASELINE TECHNOLOGIES FOR PLATFORM UTILIZING THE SCRIPTS.  THIRD PARTY LIMITATIONS
# APPLY WITHIN THE SPECIFICS THEIR RESPECTIVE UTILIZATION AGREEMENTS AND LICENSES.  AUTHOR DOES NOT
# AUTHORIZE RESALE, LEASE, OR CHARGE FOR UTILIZATION OF THESE SCRIPTS BY ANY THIRD PARTY.
#
# SCRIPTLET :  MDSM Reassign Global Assignmnents on the current MDS
#
# Version created 2020-12-22 1900 hrs CDT
#
ScriptDate=2022-02-24
ScriptVersion=05.28.01
ScriptRevision=000
TemplateVersion=05.28.01
TemplateLevel=006
SubScriptsLevel=010
SubScriptsVersion=05.28.01
#



#clish -c "show web ssl-port"
#MGMTSSLPORT=4344
clish -i -c "lock database override"
clish -i -c "lock database override"

GETWEBSSLPORT=`clish -c "show web ssl-port" | awk '{print $2}'`
export MGMTSSLPORT=$GETWEBSSLPORT

echo 'web SSL Port = '${MGMTSSLPORT}
echo

echo '"global-domains","dependent-domains"' > global-assignment.header.csv
cat global-assignment.header.csv > global-assignment.csv

mgmt_cli -r true --port ${MGMTSSLPORT} show global-assignments details-level full -f json | $JQ '.objects[] | [ .["global-domain"]["name"], .["dependent-domain"]["name"] ] | @csv' -r > global-assignment.data.csv

cat global-assignment.data.csv >> global-assignment.csv

cat global-assignment.csv

mgmt_cli -r true --port ${MGMTSSLPORT} -f json assign-global-assignment --batch global-assignment.csv

