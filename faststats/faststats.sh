#!/bin/bash

export REAL_DIR=
export FAKE_DIR=

BIN=$(dirname $(readlink -f $0))
. ${BIN}/faststats_setup.sh && exec ${BIN}/faststats_loop.sh
