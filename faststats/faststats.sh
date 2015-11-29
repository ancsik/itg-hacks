#!/bin/bash

export REAL_DIR=
export FAKE_DIR=
export CLEANSTATS_SH=

FSBIN=$(dirname $(readlink -f $0))
. ${FSBIN}/fs-init.sh
exec ${FSBIN}/fs-loop.sh
