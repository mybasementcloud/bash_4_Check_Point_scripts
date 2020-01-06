[Expert@CORE-G2-Mgmt-1:0]# python /opt/CPsuite-R80.20/fw1/scripts/get_platform.py
platform_name: "Linux"
release: "Check Point Gaia R80.20"
computer_name: "CORE-G2-Mgmt-1"
is_windows: "False"
is_linux: "True"
is_gaia: "True"
is_known_os: "True"

[Expert@CORE-G2-Mgmt-1:0]# python /opt/CPsuite-R80.20/fw1/scripts/get_platform.py --help
usage: This script returns information about the platform running on this machine
       [-h] [-f {text,json}]

optional arguments:
  -h, --help            show this help message and exit
  -f {text,json}, --format {text,json}
                        Output format

[Expert@CORE-G2-Mgmt-1:0]# python /opt/CPsuite-R80.20/fw1/scripts/get_platform.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .release'
"Check Point Gaia R80.20"

export get_platform_release=`python $MDS_FWDIR/scripts/get_platform.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .release'`
export platform_release=${get_platform_release//\"/}
echo $platform_release
export get_platform_release_version=`echo ${get_platform_release//\"/} | cut -d " " -f 4`
export platform_release_version=${get_platform_release_version//\"/}
echo $platform_release_version

[Expert@CORE-G2-Mgmt-1:0]# export get_platform_release=`python $MDS_FWDIR/scripts/get_platform.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .release'`
[Expert@CORE-G2-Mgmt-1:0]# export platform_release=${get_platform_release//\"/}
[Expert@CORE-G2-Mgmt-1:0]# echo $platform_release
Check Point Gaia R80.20
[Expert@CORE-G2-Mgmt-1:0]# export get_platform_release_version=`echo ${get_platform_release//\"/} | cut -d " " -f 4`
[Expert@CORE-G2-Mgmt-1:0]# export platform_release_version=${get_platform_release_version//\"/}
[Expert@CORE-G2-Mgmt-1:0]# echo $platform_release_version
R80.20
[Expert@CORE-G2-Mgmt-1:0]#

# Requires that $JQ is properly defined in the script
# so $UseJSONJQ = true must be set on template version 2.0.0 and higher
#

export pythonpath=$MDS_FWDIR/Python/bin/
export get_platform_release=`$pythonpath/python $MDS_FWDIR/scripts/get_platform.py -f json | $JQ '. | .release'`
export platform_release=${get_platform_release//\"/}
echo $platform_release
export get_platform_release_version=`echo ${get_platform_release//\"/} | cut -d " " -f 4`
export platform_release_version=${get_platform_release_version//\"/}
echo $platform_release_version




# Removing dependency on clish to avoid collissions when database is locked
#
#clish -i -c "lock database override" >> $gaiaversionoutputfile
#clish -i -c "lock database override" >> $gaiaversionoutputfile
#
#export gaiaversion=$(clish -i -c "show version product" | cut -d " " -f 6)

# Requires that $JQ is properly defined in the script
# so $UseJSONJQ = true must be set on template version 2.0.0 and higher
#
# Test string, use this to validate if there are problems:
#
#export pythonpath=$MDS_FWDIR/Python/bin/;echo $pythonpath;echo
#$pythonpath/python --help
#$pythonpath/python --version
#
export pythonpath=$MDS_FWDIR/Python/bin/
if $UseJSONJQ ; then
    export get_platform_release=`$pythonpath/python $MDS_FWDIR/scripts/get_platform.py -f json | $JQ '. | .release'`
else
    export get_platform_release=`$pythonpath/python $MDS_FWDIR/scripts/get_platform.py -f json | ${CPDIR_PATH}/jq/jq '. | .release'`
fi

export platform_release=${get_platform_release//\"/}
export get_platform_release_version=`echo ${get_platform_release//\"/} | cut -d " " -f 4`
export platform_release_version=${get_platform_release_version//\"/}

export gaiaversion=$platform_release_version

