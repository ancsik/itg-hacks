#!/bin/bash

cd $(dirname $(readlink -f $0))

CMDNAME=$(basename $0)
info() { (echo "${CMDNAME}[INFO] $@" >&2) }

TEST_DIR='/tmp/fs-test'
REAL="${TEST_DIR}/real"
FAKE="${TEST_DIR}/fake"
STATS_XML="stats.xml"
STATS_SIG="stats.xml.sig"

info "creating test dirs"
[ -f ${TEST_DIR} ] && rm -rf ${TEST_DIR} >/dev/null
mkdir -p ${TEST_DIR} ${REAL} >/dev/null

info "initializing test files"
echo "does not change" >${REAL}/staticfile.txt
echo "does change" >"${REAL}/${STATS_XML}"
echo "also changes" >"${REAL}/${STATS_SIG}"

info "faststats setup"
export REAL_DIR="${REAL}"
export FAKE_DIR="${FAKE}"
. fs-init.sh

# define test updates
append() { (echo "$1 change $2" | tee -a "${FAKE}/$1") }
update() { (append ${STATS_XML} $1; sleep 2; append ${STATS_SIG} $1) }

# run the loop a few times
./faststats_loop.sh&
LOOP=$!
info "letting the loop get initialized"; sleep 3
C=0; while [ ${C} -lt 5 ]; do C=$((C+1)); update ${C}; sleep 1; done
kill ${LOOP}