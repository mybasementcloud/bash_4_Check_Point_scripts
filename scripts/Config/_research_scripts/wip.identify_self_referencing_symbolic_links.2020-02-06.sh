[Expert@CORE-G2-EP-Mgmt-1:0]# history
    1  df -i
    2  df -ih
    3  cd $CPRPT
    4  pwd
    5  set
    6  cd $RTDIR
    7  pwd
    8  list
    9  cd log_indexes
   10  ll
   11  ls -i
   12  ls -alhi
   13  cd audit_2018-03-11T00-00-00
   14  ls -alhi
   15  pwd
   16  ln --help
   17  rm --help
   18  ls --help
   19  list
   20  ls -aghi
   21  pathchk --help
   22  list
   23  pathchk audit_2018-03-11T00-00-00
   24  pathchk audit_2018-03-11T00-00-00; echo $?
   25  pathchk data; echo $?
   26  ls -lrt  `find ./ -follow -type l`
   27  find . -follow -printf ""
   28  find . -type l
   29  pwd
   30  ls -lrt  `find / -follow -type l`
   31  history
   32  find . -follow -type l -exec ls -lrt {} \;
   33  find . -follow -type l
   34  find . -follow -type l;echo $?
   35  pwd
   36  cd ..
   37  list audit_2020*
   38  cd audit_2020-02-06T00-00-00
   39  find . -follow -type l;echo $?
   40  find . -follow -type l
   41  cd ../audit_2020-01-29T00-00-00
   42  find . -follow -type l
   43  list
   44  cd ../audit_2020-01-01T00-00-00
   45  list
   46  cd ..
   47  history
   48  list audit_2019-12*
   49  cd audit_2019-12-31T00-00-00
   50  list
   51  cd ../audit_2019-12-01T00-00-00
   52  list
   53  cd ..
   54  list audit_2019-11*
   55  list audit_2019-11-01T00-00-00
   56  cd audit_2019-11-01T00-00-00
   57  list
   58  cd ..
   59  list audit_2019-05*
   60  cd audit_2019-05-11T00-00-00
   61  list
   62  cd ..
   63  pwd
   64  cd audit_2019-05-12T00-00-00
   65  list
   66  cd ..
   67  history
   68  find . -follow -type l
   69  cd audit_2019-05-12T00-00-00
   70  find . -follow -type l
   71  cd ..
   72  cd audit_2019-05-11T00-00-00
   73  find . -follow -type l
   74  for f in $(find . -type l); do if [ ! -e "$f" ]; then echo "$f"; fi; done
   75  pwd
   76  list
   77  for f in $(find .. -type l); do if [ ! -e "$f" ]; then echo "$f"; fi; done
   78  find . -type l
   79  find . -type l | while read f; do if [ ! -e "$f" ]; then ls -l "$f"; fi; done
   80  find . -xtype l
   81  find . -type l
   82  find . --follow -type l
   83  find . -follow -type l
   84  for f in $(find . -follow -type l); echo "$f"; done
   85  for f in $(find . -follow -type l); do echo "$f"; done
   86  find -type l -exec ls -l {} .;
   87  find . -type f -follow -print
   88  find . -type l -follow -print
   89  find . | sed -e 's/[^-][^\/]*\//--/g;s/--/ |-/'
   90  find . -type f -follow -print | sed -e 's/[^-][^\/]*\//--/g;s/--/ |-/'
   91  find . -type l -follow -print | sed -e 's/[^-][^\/]*\//--/g;s/--/ |-/'
   92  pwd
   93  list
   94  find . -type l
   95  ls $(find . -type l)
   96  ls -i $(find . -type l)
   97  ls -g $(find . -type l)
   98  pwd
   99  cd ./audit_2019-05-11T00-00-00
  100  pwd
  101  list
  102  cd ..
  103  pwd
  104  cd audit_2019-05-11T00-00-00
  105  pwd
  106  ls -rl
  107  ls -r
  108  ls -l
  109  pushd /var/log/opt/CPrt-R80.30/log_indexes/audit_2019-05-11T00-00-00/
  110  list
  111  pwd
  112  find -exec sh -c 'readlink -f "$0" &> /dev/null || echo "$0"' {} \;
  113  list
  114  readlink --help
  115  readlink audit_2019-05-11T00-00-00
  116  pwd
  117  if [ $(readlink audit_2019-05-11T00-00-00) = $(pwd) ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi
  118  if [ `readlink audit_2019-05-11T00-00-00` = `pwd`) ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi
  119  if [ `readlink audit_2019-05-11T00-00-00` = `pwd` ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi
  120  testlink=`readlink audit_2019-05-11T00-00-00`; localfolder=`pwd`; if [ $testlink = $localfolder ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi
  121  testlink=`readlink audit_2019-05-11T00-00-00`; localfolder=`pwd`; echo 'testlink   ='$testlink; echo 'localfolder='$localfolder; if [ $testlink = $localfolder ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi
  122  testlink=`readlink audit_2019-05-11T00-00-00`; localfolder=`pwd`; echo 'testlink   ='$testlink; echo 'localfolder='$localfolder; if [ $testlink = $localfolder/ ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi
  123  history
  124  for f in $(find . -type l); do testlink=`readlink $f`; localfolder=`pwd`; echo 'testlink   ='$testlink; echo 'localfolder='$localfolder; if [ $testlink = $localfolder/ ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi ; done
  125  popd
  126  pwd
  127  cd ..
  128  pwd
  129  cd ..
  130  pwd
  131  list
  132  history
  133  for f in $(find . -type l); do testlink=`readlink $f`; localfolder=`pwd`; echo 'testlink   ='$testlink; echo 'localfolder='$localfolder; if [ $testlink = $localfolder/ ]; then echo 'Link points to itself'; else echo 'Not self referencing'; fi ; done
  134  history
[Expert@CORE-G2-EP-Mgmt-1:0]#
  135  gougex
  136  history
  137  for f in $(find ${RTDIR} -type l); do echo 'Link File : '$f; done; echo
  138  for f in $(find ${RTDIR}/log_indexes -type l); do echo 'Link File : '$f; done; echo
  139  for f in $(find ${RTDIR}/log_indexes/ -type l); do echo 'Link File : '$f; done; echo
  140  for f in $(find ${RTDIR}/log_indexes/ -type l); do echo 'Link File : '$f'  Actual Link target: '`readlink $f`; done; echo
  141  history


[Expert@CORE-G2-EP-Mgmt-1:0]# history
    1  history
    2  list
    3  list scripts/MGMT/
    4  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.000.sh
    5  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.000.sh
    6  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
    7  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
    8  pushd --help
    9  help pushd
   10  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   11  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   12  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   13  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   14  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh --NOWAIT
   15  history
   16  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   17  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   18  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   19  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   20  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   21  pwd
   22  find /var/log/opt/CPrt-R80.20/log_indexes/audit_2018-03-13T00-00-00 -type l -follow -print 2>> grep './audit_2018-03-13T00-00-00'
   23  find /var/log/opt/CPrt-R80.20/log_indexes/audit_2018-03-13T00-00-00 -type l -follow -print
   24  find /var/log/opt/CPrt-R80.20/log_indexes/audit_2018-03-13T00-00-00 -type l -follow -print 2>> grep 'audit_2018-03-13T00-00-00'
   25  pushd /var/log/opt/CPrt-R80.20/log_indexes/audit_2018-03-13T00-00-00
   26  list
   27  find . -type l -follow
   28  echo $(find . -type l -follow)
   29  testfind=$(find . -type l -follow); echo $testfind
   30  dumpfile=/tmp/dumpfile.$DATEDTGS.txt;echo $dumpfile
   31  dumpfile=/tmp/dumpfile.`DATEDTGS`.txt;echo $dumpfile
   32  dumpfile=/tmp/dumpfile.`$DATEDTGS`.txt;echo $dumpfile
   33  dumpfile=/tmp/dumpfile.`DTGSDATE`.txt;echo $dumpfile
   34  dumpfile=/tmp/dumpfile.`DTGSDATE`.txt;echo $dumpfile; find . -type l -follow 2>> $dumpfile; cat $dumpfile
   35  dumpfile=/tmp/dumpfile.`DTGSDATE`.txt;echo $dumpfile; find . -type l -follow 2>> $dumpfile; echo; echo; cat $dumpfile
   36  pwd
   37  popd
   38  history
   39  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   40  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.002.sh
   41  history
   42  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.012.sh
   43  ./do_script_nohup ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.012.sh
   44  ./.nohup.2020-02-06-150535CST.identify_self_referencing_symbolic_link_files.v01.00.00.012.sh.watchme.sh
   45  list
   46  ./.nohup.2020-02-06-150535CST.identify_self_referencing_symbolic_link_files.v01.00.00.012.sh.cleanup.sh
   47  pwd
   48  cp /var/log/upgrade-export.3Feb2020* .
   49  df -h
   50  grep --help
   51  list
   52  mkdir reference
   53  history
   54  help pushd > reference/help.pushd.R80.40.help.txt
   55  help grep > reference/help.grep.R80.40.help.txt
   56  grep --help > reference/help.grep.R80.40.help.txt
   57  find --help > reference/help.find.R80.40.help.txt
   58  echo --help > reference/help.echo.R80.40.help.txt
   59  ls --help > reference/help.ls.R80.40.help.txt
   60  list reference/
   61  history
   62  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.015.sh
   63  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.015.sh
   64  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.015.sh
   65  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.015.sh
   66  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.015.sh
   67  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.015.sh
   68  history
   69  ./do_script_nohup ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.015.sh
   70  ./.nohup.2020-02-06-153410CST.identify_self_referencing_symbolic_link_files.v01.00.00.015.sh.watchme.sh
   71  history
   72  cls
   73  list
   74  ./.nohup.2020-02-06-153410CST.identify_self_referencing_symbolic_link_files.v01.00.00.015.sh.cleanup.sh
   75  cls list
   76  list
   77  list
   78  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh
   79  pwd
   80  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh
   81  list
   82  stat --help
   83  history
   84  stat --help > reference/help.echo.R80.40.help.txt
   85  echo --help > reference/help.echo.R80.40.help.txt
   86  stat --help > reference/help.stat.R80.40.help.txt
   87  list
   88  stat -L EPM_config_check
   89  stat -L -c EPM_config_check
   90  stat -L -c %F EPM_config_check
   91  stat -L -c ${RTDIR}/log_indexes/
   92  stat -L -c %F ${RTDIR}/log_indexes/
   93  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh
   94  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh
   95  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh
   96  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh
   97  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh --Path="${RTDIR}/log_indexes/"
   98  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh -v --Path="${RTDIR}/log_indexes/"
   99  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh -v --Path="${RTDIR}/log_indexes/"
  100  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh -v --Path="${RTDIR}/log_indexes/"
  101  ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh --Path="${RTDIR}/log_indexes/" --kill
  102  ./do_script_nohup ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.020.sh --Path="${RTDIR}/log_indexes/" --kill
  103  ./.nohup.2020-02-06-163845CST.identify_self_referencing_symbolic_link_files.v01.00.00.020.sh.watchme.sh
  104  list
  105  ./.nohup.2020-02-06-163845CST.identify_self_referencing_symbolic_link_files.v01.00.00.020.sh.cleanup.sh
  106  list
  107  ./do_script_nohup ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.025.sh --Path="${RTDIR}/log_indexes/"
  108  ./.nohup.2020-02-06-164730CST.identify_self_referencing_symbolic_link_files.v01.00.00.025.sh.watchme.sh
  109  ./.nohup.2020-02-06-164730CST.identify_self_referencing_symbolic_link_files.v01.00.00.025.sh.cleanup.sh
  110  list
  111  ./do_script_nohup ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.025.sh --Path="${RTDIR}/log_indexes/"
  112  ./.nohup.2020-02-06-170403CST.identify_self_referencing_symbolic_link_files.v01.00.00.025.sh.watchme.sh
  113  list /var/log/opt/CPrt-R80.20/log_indexes/audit_2018-03-11T00-00-00//./audit_2018-03-11T00-00-00
  114* ./.nohup.2020-02-06-170403CST.identify_self_referencing_symbolic_link_files.v01.00.00.0.sh.cleanup.sh
  115  list
  116  ./do_script_nohup ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.030.sh --Path="${RTDIR}/log_indexes/"
  117  ./.nohup.2020-02-06-171833CST.identify_self_referencing_symbolic_link_files.v01.00.00.030.sh.watchme.sh
  118  ./.nohup.2020-02-06-171833CST.identify_self_referencing_symbolic_link_files.v01.00.00.030.sh.cleanup.sh
  119  list
  120  pushd /var/log/opt/CPrt-R80.20/log_indexes/audit_2018-03-11T00-00-00/
  121  list
  122  /var/log/__customer/upgrade_export/scripts/_template/Code_Snipets/code_snipet.break_filename_into_parts.sh ./audit_2018-03-11T00-00-00
  123  popd
  124  ./do_script_nohup ./scripts/MGMT/identify_self_referencing_symbolic_link_files.v01.00.00.030.sh --Path="${RTDIR}/log_indexes/"
  125  ./.nohup.2020-02-06-172820CST.identify_self_referencing_symbolic_link_files.v01.00.00.030.sh.watchme.sh
  126  ./.nohup.2020-02-06-172820CST.identify_self_referencing_symbolic_link_files.v01.00.00.030.sh.cleanup.sh
  127  list
  128  history
[Expert@CORE-G2-EP-Mgmt-1:0]#


