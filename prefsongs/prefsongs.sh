#!/bin/bash

SONGLIST='/tmp/songs'

CMDNAME=$(basename $0)
# log failure and exit
usage() { (echo "${CMDNAME}[FAIL] usage: ${CMDNAME} {add,rm} PACK/SONG [PACK/SONG [...]]
  => actual: ${CMDNAME} $@" >&2; exit 1) }

# args
[ "$1" == 'add' ] || [ "$1" == 'rm' ] || usage "$@"
[ "$2" ] || usage "$@"
OP=$1; shift
SONGS=$(IFS=$'\n'; for S in $@; do echo "${S%/}"; done)

# operations
if [ "${OP}" == 'add' ]; then
  echo "${SONGS}" >> "${SONGLIST}"
  cat "${SONGLIST}" | sort -t $'\n' | uniq | tee "${SONGLIST}"
fi
if [ "${OP}" == 'rm' ]; then
  grep -vx -F "${SONGS}" "${SONGLIST}" | sort -t $'\n' | tee "${SONGLIST}"
fi
