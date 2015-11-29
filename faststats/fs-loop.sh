#!/bin/bash

# util
CMDNAME=$(basename $0)
fail() { (echo "${CMDNAME}[FAIL] $@" >&2; exit 1) }
foreach() { CMD=$1; shift; for X in $@; do ${CMD} ${X}; done }

# config
STATS_XML='stats.xml'
FILES="${STATS_XML} stats.xml.sig"
[ ${REAL_DIR} ] || fail "env REAL_DIR not set"
[ ${TEMP_DIR} ] || fail "env TEMP_DIR not set"
[ -f "${TEMP_DIR}/${STATS_XML}" ] || fail "no ${STATS_XML} in ${TEMP_DIR}"

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

# copy directly to temp location on disk
direct_copy() { (cp "${TEMP_DIR}/${1}" "${REAL_DIR}/.${1}.tmp") }
# run cleanstats in lieu of a straight copy
clean_copy() { ${CLEANSTATS_SH} "${TEMP_DIR}/${1}" > "${REAL_DIR}/.${1}.tmp" }
# pick which copy func to use
do_clean() { ([ "${CLEANSTATS_SH}" ] && [ "${1}" == "${STATS_XML}" ]) }
copyfile() { (do_clean && clean_copy $1 || direct_copy $1) }
# move to correct file names on disk (and back up existing versions)
finalize() { (F="${REAL_DIR}/${1}"; ln -f "${F}" "${F}.bak"; mv "${F}.tmp" "${F}") }

# loop until killed
while true; do
  watch_file ${STATS_XML}
  foreach wait_upd ${FILES}
  foreach copyfile ${FILES}
  foreach finalize ${FILES}
done
