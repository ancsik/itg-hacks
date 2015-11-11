#!/bin/bash

SONGLIST=
TMP=$(date +/tmp/prefsongs.%s.%N)

CMDNAME=$(basename $0)
# log failure and exit
fail() { (echo "${CMDNAME}[FAIL] $@" >&2; exit 1) }

# args
if [ $1 -ne 'add' ] && [ $1 -ne 'rm' ] && ! [ $2 ]; then
  fail "usage: ${CMDNAME} {add,rm} PACK/SONG [PACK/SONG [...]]
  => actual: ${CMDNAME} $@"
fi
OP=$1; shift
for S in $@; do echo ${S%/} >> ${TMP}; done

# operations
[ ${OP} == 'add' ] && cat ${SONGLIST} ${TMP} | sort | uniq > ${SONGLIST}
[ ${OP} == 'rm'  ] && grep -vx -f ${TMP} ${SONGLIST} | sort | uniq > ${SONGLIST}
rm ${TMP}
