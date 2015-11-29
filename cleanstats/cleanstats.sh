#!/bin/bash

CMD=$(basename $0)
stderr() { (echo -e "$@" >&2) }
usage() { (stderr "${CMD}[FAIL] usage: ${CMD} INPUT\n  => actual: ${CMD} $@") }

[ "$1" ] || (usage "$@" && exit 1)

DEL='CalorieData CoinData CoinDataService'
del() { (echo -en "\n   -e /[[:space:]]*<${1}${2}>.*<\/${1}>/d") }
exprs() { (for E in ${DEL}; do del "${E}"; done; del Song "\s*Dir='@mc.*'\s*") }

SED_CMD="sed -rz ${1} $(exprs)"
stderr "running command:\n ${SED_CMD}"
exec ${SED_CMD}
