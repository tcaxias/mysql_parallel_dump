#!/bin/bash

which parallel >/dev/null || exit "Please install GNU Parallel"

[ "`seq 5|parallel echo {} | md5sum | head -c5`" == "a7b1a" ] || { echo "Please install GNU Parallel, not the one provided in 'moreutils'" && exit 1; }

[ "$#" == "1" ] || { echo "Usage: $0 OUT_DATABASE" && exit 1; }

OUT_DB=$1

for i in *.sql.gz ; do echo $i ; done | parallel 'zcat {} | mysql' $OUT_DB' ; echo "finished: {.}"'
