#!/bin/bash

CMDNAME=$(basename $0)
# log failure and exit
fail() { (echo "${CMDNAME}[FAIL] $@" >&2; exit 1) }
info() { (echo "${CMDNAME}[INFO] $@" >&2) }
# relative path to canonical+absolute path
deref() { ([ $1 ] || fail "deref <PATH>"; readlink -f $1) }
# canonical+absolute path symlinks
symlink() { [ $2 ] || fail "symlink() <SYM> <FILE>"
  SYM="$(deref $1)"; FILE="$(deref $2)"; info "symlink: ${SYM} => ${FILE}"
  ln -sf ${FILE} ${SYM}
}
export REAL_DIR=$(deref ${REAL_DIR})
export FAKE_DIR=$(deref ${FAKE_DIR})
export TEMP_DIR='/tmp/faststats'

info "setting up '${FAKE_DIR}' and '${TEMP_DIR}', backed by '${REAL_DIR}'"
# make a clean TEMP_DIR
rm -rf ${TEMP_DIR} && mkdir ${TEMP_DIR} || fail "could not create dir '${TEMP_DIR}'"
# if FAKE_DIR exists, delete it
[ -f ${FAKE_DIR} ] && (rm -rf ${FAKE_DIR} || fail "fake dir '${FAKE_DIR}' exists, but rm failed")

info "adding symlinks between dirs"
symlink "${FAKE_DIR}" "${TEMP_DIR}"
# make every file other than stats.xml* point to the real profile
for FILE in $(ls ${REAL_DIR} | grep -v 'stats.xml')
do BASE=$(basename ${FILE}); symlink "${TEMP_DIR}/${BASE}" "${REAL_DIR}/${BASE}"
done

# copy the real stats.xml* files into memory
FILES='stats.xml stats.xml.sig'
for F in ${FILES}; do cp "${REAL_DIR}/${F}" "${TEMP_DIR}/${F}"; done
