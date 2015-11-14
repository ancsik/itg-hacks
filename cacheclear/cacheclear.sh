#!/bin/bash

CACHE=

# args and directory
[ $1 ] || (echo "USAGE: \`cacheclear.sh PACK [SONG]\`" && exit 1)
[ $(basename $(pwd)) == "Songs" ] || (echo "ERROR: cd /to/itg/Songs" && exit 1)

# build match list
is_song() { ([ "$1" == 'mp3' ] || [ "$1" == 'ogg' ]) }
list() {
  for F in $(if [ "$2" ]; then ls "$1/$2"/*; else ls "$1"/*/*; fi)
  do is_song "${F##*.}" && echo "${F##*/}"
  done
}
# check for matches in the cache
check_cache() {
  LIST=$(list "$1" "$2")

  for F in $(ls "${CACHE}"); do
    F="${CACHE}/${F##*/}"
    MATCH=$(head -n 20 "${F}" | grep -o -m 1 -F "${LIST}")
    [ "${MATCH}" ] && echo "[${MATCH}] $(rm -v "${F}")"
  done
}

(IFS=$'\n'; check_cache "$1" "$2")
