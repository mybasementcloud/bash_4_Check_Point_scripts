python $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'

[Expert@server:0]# python $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'
"4434"

api_local_port=`python $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'`;echo ${api_local_port//\"/};echo

[Expert@server:0]# api_local_port=`python $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'`;echo ${api_local_port//\"/};echo
4434

or

get_api_local_port=`python $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'`
api_local_port=${get_api_local_port//\"/}
echo $api_local_port

[Expert@server:0]# get_api_local_port=`python $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'`
[Expert@server:0]# api_local_port=${get_api_local_port//\"/}
[Expert@server:0]# echo $api_local_port
4434


export get_api_local_port=`$pythonpath/python  $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'`
export api_local_port=${get_api_local_port//\"/}
echo $api_local_port


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
    export get_api_local_port=`$pythonpath/python  $MDS_FWDIR/scripts/api_get_port.py -f json | $JQ '. | .external_port'`
else
    export get_api_local_port=`$pythonpath/python  $MDS_FWDIR/scripts/api_get_port.py -f json | /opt/CPshrd-R80.20/jq/jq '. | .external_port'`
fi

export api_local_port=${get_api_local_port//\"/}
echo $api_local_port



