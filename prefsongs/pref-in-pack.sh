#!/bin/sh

BIN=$(dirname $(readlink -f $0))

# config
OP=$1; shift
PACK=$(basename $(pwd))
SONGS=''; for SONG in $@; do SONGS+="'${PACK}/${SONG}' "; done

# run
exec ${BIN}/prefsongs.sh ${OP} ${SONGS}

