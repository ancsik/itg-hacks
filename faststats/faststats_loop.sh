#!/bin/bash

# util
CMDNAME=$(basename $0)
fail() { (echo "${CMDNAME}[FAIL] $@" >&2; exit 1) }
foreach() { CMD=$1; shift; for X in $@; do ${CMD} ${X}; done }

# config
[ ${REAL_DIR} ] || fail "REAL_DIR not set"
[ ${TEMP_DIR} ] || fail "TEMP_DIR not set"
[ -f "${TEMP_DIR}/stats.xml" ] || fail "no stats.xml in ${TEMP_DIR}"
FILES='stats.xml stats.xml.sig'

# update timestamps
last_upd() { (stat -c %Z "${TEMP_DIR}/$1") }
declare -A UPDATED; for F in ${FILES}; do UPDATED[${F}]=$(last_upd ${F}); done
fresh() { ([ ${UPDATED[$1]} == $(last_upd "$1") ]) }

# waiting
wait_upd() {
  OLD=${UPDATED[$1]} ; NEW=$(last_upd "$1")
  while [ ${OLD} == ${NEW} ]; do sleep 1; NEW=$(last_upd "$1"); done
  UPDATED[${1}]=${NEW}
}
wait_on_write() {
  while fresh $1; do
    inotifywait --timeout 60 -e close_write "${TEMP_DIR}/$1" >&2
    [ $? == 0 ] && return 0
  done
}

# copy to temp location on disk
to_disk() { (cp "${TEMP_DIR}/${1}" "${REAL_DIR}/.${1}.tmp") }
# move to correct file names on disk
finalize() { (mv "${REAL_DIR}/.${1}.tmp" "${REAL_DIR}/${1}") }

# loop until killed
while true; do
  wait_on_write 'stats.xml'
  foreach wait_upd ${FILES}
  foreach  to_disk ${FILES}
  foreach finalize ${FILES}
done
