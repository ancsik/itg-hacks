#!/bin/bash

CACHE=
TMP=$(date +/tmp/cacheclear.%s.%N)

# args and directory
[ $1 ] || (echo "USAGE: \`cacheclear.sh PACK [SONG]\`" && exit 1)
[ $(basename $(pwd)) == "Songs" ] || (echo "ERROR: cd /to/itg/Songs" && exit 1)

# build match list
list() { for S in $(ls -Q $1/$2/*.{mp3,ogg}); do basename ${S} >> ${TMP}; done }
if [ $2 ]; then (list "'$1'" "'$2'"); else (list "'$1'" *); fi

# check for matches in the cache
for F in $(ls -Q "${CACHE}"); do
  MATCH=$(head -n 20 "${F}" | grep -o -m 1 -f ${TMP})
  [ ${MATCH} ] && echo $(rm -v ${F}) "[${MATCH}]"
done
rm ${TMP}
