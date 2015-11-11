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
watch_file() {
  while fresh $1; do
    inotifywait --timeout 60 -e close_write "${TEMP_DIR}/$1" >&2
    [ $? == 0 ] && return 0
  done
}

# copy to temp location on disk
diskcopy() { (cp "${TEMP_DIR}/${1}" "${REAL_DIR}/.${1}.tmp") }
# move to correct file names on disk (and back up existing versions)
finalize() { (F="${REAL_DIR}/${1}"; ln -f "${F}" "${F}.bak"; mv "${F}.tmp" "${F}") }

# loop until killed
while true; do
  watch_file 'stats.xml'
  foreach wait_upd ${FILES}
  foreach diskcopy ${FILES}
  foreach finalize ${FILES}
done
