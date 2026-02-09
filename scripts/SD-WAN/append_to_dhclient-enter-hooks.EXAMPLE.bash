#******************************************************
# SD-WAN Fix for DHCP Issue when DNS is set for Internal DNS Servers
# Gateway      :  EXAMPLE
# Last Modified:  2026-02-08:01
#
case ${interface} in
   ( 'eth0' | 'eth1' | 'eth2' | 'eth3' | 'eth4' | 'eth5' | 'eth6' | 'eth7' | 'eth8' | 'eth9' )
       export PEERDNS="no"
       ;;
   ( 'bond0.2' | 'bond0.3' | 'bond0.4' )
       export PEERDNS="no"
       ;;
   ( 'bond1.13' | 'bond1.14' | 'bond1.15' | 'bond1.16' )
       export PEERDNS="no"
       ;;
   ( * )
       export PEERDNS="yes"
       ;;
esac
#******************************************************
