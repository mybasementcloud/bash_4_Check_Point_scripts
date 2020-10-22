DOMAINSARRAY=()

GETDOMAINS="`mgmt_cli show domains -r true --port $MGMTSSLPORT --format json | jq '.objects[].name'`"

DOMAINSARRAY+=("System Data")
echo -n 'Domains :  "System Data" '
DOMAINSARRAY+=("Global")
echo -n ', "Global" '

arraylength=2
while read -r line; do

    if [ $arraylength -eq 0 ]; then
    	echo -n 'Domains :  '
    else
    	echo -n ', '
    fi

    DOMAINSARRAY+=("$line")
    echo -n /"$line/"

    #if [ "$line" == 'lo' ]; then
    #    echo -n 'Not adding '$line
    #else 
    #    DOMAINSARRAY+=("$line")
    #    echo -n $line
    #fi
	
	arraylength=${#DOMAINSARRAY[@]}
	arrayelement=$((arraylength-1))
	
done <<< "$GETDOMAINS"

echo 'Show list of domains in array'
echo
for j in "${DOMAINSARRAY[@]}"
do
    echo /"$j/"
done
echo

