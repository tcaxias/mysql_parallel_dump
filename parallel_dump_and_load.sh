#!/bin/bash

which parallel >/dev/null || exit "Please install GNU Parallel"

[ "`seq 5|parallel echo {} | md5sum | head -c5`" == "a7b1a" ] || { echo "Please install GNU Parallel, not the one provided in 'moreutils'" && exit 1; }

[ "$#" == "2" ] || { echo "Usage: $0 IN_DATABASE OUT_DATABASE" && exit 1; }

IN_DB=$1
OUT_DB=$2

for i in `mysql --defaults-group-suffix=read $1 -e "show tables"` ; do echo $i ; done | parallel 'mysqldump --defaults-group-suffix=read -f --single-transaction --opt --skip-comments --routines' $IN_DB '{} | sed -e "s/\/\*!5001[3,7] DEFINER[ ]*=[ ]*[^*]*\*\///" |  mysql --defaults-group-suffix=write' $OUT_DB '; echo "finished: {}"'

