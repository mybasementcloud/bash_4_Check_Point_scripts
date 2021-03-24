[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]# export iface=bond0; expr substr $iface 1 4
bond
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; echo $chkiface
bond
[Expert@beasleysmcias-01:0]# export iface=bond0; if [ `expr substr $iface 1 4` eq 'bond' ] ; then echo 'yes'; else echo 'no'; fi
-bash: [: eq: binary operator expected
no
[Expert@beasleysmcias-01:0]# export iface=bond0; if [ `expr substr $iface 1 4` = 'bond' ] ; then echo 'yes'; else echo 'no'; fi
yes
[Expert@beasleysmcias-01:0]# export iface=bond0; export isbond=[ `expr substr $iface 1 4` = 'bond' ]; if $isbond ; then echo 'yes'; else echo 'no'; fi
-bash: export: `=': not a valid identifier
-bash: export: `]': not a valid identifier
-bash: [: missing `]'
no
[Expert@beasleysmcias-01:0]# export iface=bond0; export isbond=(`expr substr $iface 1 4` = 'bond') ; if $isbond ; then echo 'yes'; else echo 'no'; fi
-bash: bond: command not found
no
[Expert@beasleysmcias-01:0]# export iface=bond0; export isbond=`[[ `expr substr $iface 1 4` = 'bond' ]]` ; if $isbond ; then echo 'yes'; else echo 'no'; fi
-bash: command substitution: line 2: unexpected token `EOF' in conditional command
-bash: command substitution: line 2: syntax error: unexpected end of file
-bash: =: command not found
-bash: export: `1': not a valid identifier
-bash: export: `4': not a valid identifier
expr: missing operand
Try 'expr --help' for more information.
no
[Expert@beasleysmcias-01:0]# echo $iface
bond0
[Expert@beasleysmcias-01:0]# echo $chkiface
bond
[Expert@beasleysmcias-01:0]# export iface=eth0
[Expert@beasleysmcias-01:0]# echo $chkiface
bond
[Expert@beasleysmcias-01:0]# echo "$chkiface"
bond
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chiface"="bond"`; echo $chkiface; echo $isbond
-bash: =bond: command not found
bond

[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chkiface"='bond'`; echo $chkiface; echo $isbond
-bash: bond=bond: command not found
bond

[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chkiface" = 'bond'`; echo $chkiface; echo $isbond
-bash: bond: command not found
bond

[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo $chkiface; echo $isbond
bond

[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'chkiface = '$chkiface; echo 'isbond  = '$isbond
chkiface = bond
isbond  =
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'iface    = '$iface; echo 'chkiface = '$chkiface; echo 'isbond   = '$isbond
iface    = bond0
chkiface = bond
isbond   =
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = bond ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`$chkiface = bond`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
-bash: bond: command not found
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[ $chkiface = bond ]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[ "bond" = "$chkiface" ]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ "bond" = "$chkiface" ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=[[ "bond" = "$chkiface" ]]; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
-bash: export: `=': not a valid identifier
-bash: export: `]]': not a valid identifier
iface    = >bond0<
chkiface = >bond<
isbond   = >[[<
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=( "bond" = "$chkiface" ); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = >bond<
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=( "bond" = "${chkiface}" ); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = >bond<
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "${chkiface}"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
-bash: bond: command not found
iface    = >bond0<
chkiface = >bond<
isbond   = ><~
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "$chkiface"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
-bash: bond: command not found
iface    = >bond0<
chkiface = >bond<
isbond   = ><~
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "$chkiface"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
-bash: bond: command not found
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
iface    = >bond0<
chkiface = >bond<
isbond   = ><~
[Expert@beasleysmcias-01:0]# export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = ><
[Expert@beasleysmcias-01:0]# export iface=eth0
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >eth0<
chkiface = >eth0<
isbond   = ><
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export isbond=`[[ "bond" = "$chkiface" ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >eth0<
chkiface = >eth0<
isbond   = ><
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >eth0<
chkiface = >eth0<
isbond   = ><
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]; echo $?`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >eth0<
chkiface = >eth0<
isbond   = >1<
[Expert@beasleysmcias-01:0]# export iface=bond0
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]; echo $?`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = >0<
[Expert@beasleysmcias-01:0]# if $isbond; then echo "Is bond"; else echo "Not bond"; fi
-bash: 0: command not found
Not bond
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]; echo $?`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'^C
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]# if $isbond; then echo 'Is bond'; else echo 'Not bond'; fi
-bash: 0: command not found
Not bond
[Expert@beasleysmcias-01:0]# if "${isbond}" ; then echo 'Is bond'; else echo 'Not bond'; fi
-bash: 0: command not found
Not bond
[Expert@beasleysmcias-01:0]# if "$isbond" ; then echo 'Is bond'; else echo 'Not bond'; fi
-bash: 0: command not found
Not bond
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
isbond   = >false<
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0<
chkiface = >bond<
bondchk  = >0<
isbond   = >false<
[Expert@beasleysmcias-01:0]# export iface=eth0
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
iface    = >eth0<
chkiface = >eth0<
bondchk  = >1<
isbond   = >true<
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]# history
    1  gougex
    2  export iface=bond0; expr substr $iface 1 4
    3  export iface=bond0; export chkiface=`expr substr $iface 1 4`; echo $chkiface
    4  export iface=bond0; if [ `expr substr $iface 1 4` eq 'bond' ] ; then echo 'yes'; else echo 'no'; fi
    5  export iface=bond0; if [ `expr substr $iface 1 4` = 'bond' ] ; then echo 'yes'; else echo 'no'; fi
    6  export iface=bond0; export isbond=[ `expr substr $iface 1 4` = 'bond' ]; if $isbond ; then echo 'yes'; else echo 'no'; fi
    7  export iface=bond0; export isbond=(`expr substr $iface 1 4` = 'bond') ; if $isbond ; then echo 'yes'; else echo 'no'; fi
    8  export iface=bond0; export isbond=`[[ `expr substr $iface 1 4` = 'bond' ]]` ; if $isbond ; then echo 'yes'; else echo 'no'; fi
    9  echo $iface
   10  echo $chkiface
   11  export iface=eth0
   12  echo $chkiface
   13  echo "$chkiface"
   14  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chiface"="bond"`; echo $chkiface; echo $isbond
   15  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chkiface"='bond'`; echo $chkiface; echo $isbond
   16  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chkiface" = 'bond'`; echo $chkiface; echo $isbond
   17  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo $chkiface; echo $isbond
   18  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'chkiface = '$chkiface; echo 'isbond  = '$isbond
   19  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'iface    = '$iface; echo 'chkiface = '$chkiface; echo 'isbond   = '$isbond
   20  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   21  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = bond ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   22  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`$chkiface = bond`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   23  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[ $chkiface = bond ]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   24  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[ "bond" = "$chkiface" ]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   25  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ "bond" = "$chkiface" ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   26  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=[[ "bond" = "$chkiface" ]]; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   27  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=( "bond" = "$chkiface" ); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   28  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=( "bond" = "${chkiface}" ); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   29  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "${chkiface}"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
   30  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "$chkiface"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
   31  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "$chkiface"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   32  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
   33  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   34  export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   35  export iface=eth0
   36  export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   37  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ "bond" = "$chkiface" ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   38  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   39  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]; echo $?`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   40  export iface=bond0
   41  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]; echo $?`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   42* if $isbond; then echo ~
   43  if $isbond; then echo 'Is bond'; else echo 'Not bond'; fi
   44  if "${isbond}" ; then echo 'Is bond'; else echo 'Not bond'; fi
   45  if "$isbond" ; then echo 'Is bond'; else echo 'Not bond'; fi
   46  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   47  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
   48  export iface=eth0
   49  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
   50  history
[Expert@beasleysmcias-01:0]#

[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 0 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
iface    = >eth0<
chkiface = >eth0<
bondchk  = >1<
isbond   = >false<
[Expert@beasleysmcias-01:0]# export iface=bond0.2
[Expert@beasleysmcias-01:0]# export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 0 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
iface    = >bond0.2<
chkiface = >bond<
bondchk  = >0<
isbond   = >true<
[Expert@beasleysmcias-01:0]#
[Expert@beasleysmcias-01:0]# history
    1  gougex
    2  export iface=bond0; expr substr $iface 1 4
    3  export iface=bond0; export chkiface=`expr substr $iface 1 4`; echo $chkiface
    4  export iface=bond0; if [ `expr substr $iface 1 4` eq 'bond' ] ; then echo 'yes'; else echo 'no'; fi
    5  export iface=bond0; if [ `expr substr $iface 1 4` = 'bond' ] ; then echo 'yes'; else echo 'no'; fi
    6  export iface=bond0; export isbond=[ `expr substr $iface 1 4` = 'bond' ]; if $isbond ; then echo 'yes'; else echo 'no'; fi
    7  export iface=bond0; export isbond=(`expr substr $iface 1 4` = 'bond') ; if $isbond ; then echo 'yes'; else echo 'no'; fi
    8  export iface=bond0; export isbond=`[[ `expr substr $iface 1 4` = 'bond' ]]` ; if $isbond ; then echo 'yes'; else echo 'no'; fi
    9  echo $iface
   10  echo $chkiface
   11  export iface=eth0
   12  echo $chkiface
   13  echo "$chkiface"
   14  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chiface"="bond"`; echo $chkiface; echo $isbond
   15  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chkiface"='bond'`; echo $chkiface; echo $isbond
   16  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`"$chkiface" = 'bond'`; echo $chkiface; echo $isbond
   17  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo $chkiface; echo $isbond
   18  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'chkiface = '$chkiface; echo 'isbond  = '$isbond
   19  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'iface    = '$iface; echo 'chkiface = '$chkiface; echo 'isbond   = '$isbond
   20  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = 'bond' ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   21  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ $chkiface = bond ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   22  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`$chkiface = bond`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   23  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[ $chkiface = bond ]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   24  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[ "bond" = "$chkiface" ]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   25  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`[[ "bond" = "$chkiface" ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   26  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=[[ "bond" = "$chkiface" ]]; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   27  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=( "bond" = "$chkiface" ); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   28  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=( "bond" = "${chkiface}" ); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   29  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "${chkiface}"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
   30  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "$chkiface"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
   31  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=$( "bond" = "$chkiface"); echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   32  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<~'
   33  export iface=bond0; export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   34  export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   35  export iface=eth0
   36  export chkiface=`expr substr $iface 1 4`; export isbond=`test "bond" = "$chkiface"`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   37  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ "bond" = "$chkiface" ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   38  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   39  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]; echo $?`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   40  export iface=bond0
   41  export chkiface=`expr substr $iface 1 4`; export isbond=`[[ 'bond' = $chkiface ]]; echo $?`; echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   42* if $isbond; then echo ~
   43  if $isbond; then echo 'Is bond'; else echo 'Not bond'; fi
   44  if "${isbond}" ; then echo 'Is bond'; else echo 'Not bond'; fi
   45  if "$isbond" ; then echo 'Is bond'; else echo 'Not bond'; fi
   46  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'isbond   = >'$isbond'<'
   47  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
   48  export iface=eth0
   49  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 1 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
   50  history
   51  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 0 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
   52  export iface=bond0.2
   53  export chkiface=`expr substr $iface 1 4`; export bondchk=`[[ 'bond' = $chkiface ]]; echo $?`; if [ $bondchk -eq 0 ] ; then export isbond=true; else export isbond=false; fi;  echo 'iface    = >'$iface'<'; echo 'chkiface = >'$chkiface'<'; echo 'bondchk  = >'$bondchk'<'; echo 'isbond   = >'$isbond'<'
   54  history
[Expert@beasleysmcias-01:0]#