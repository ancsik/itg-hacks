#!/bin/bash

CMDNAME=$(basename $0)
# log failure and exit
fail() { (echo "${CMDNAME}[FAIL] $@" >&2; exit 1) }
# relative path to canonical+absolute path
deref() { ([ $1 ] || fail "deref <PATH>"; readlink -f $1) }
# canonical+absolute path symlinks
symlink() { [ $2 ] || fail "symlink() <SYM> <FILE>"
  SYM="$(deref $1)"; FILE="$(deref $2)"; info "symlink: ${SYM} => ${FILE}"
  ln -s ${FILE} ${SYM}
}

# env check
[ ${SYMBIN_DIR} ] || fail "run symbin-setup.sh first"
# arg check
[ $1 ] || fail "usage: symbin path/to/exec [...]"

for EXEC in $@; do symlink ${SYMBIN_DIR}/$(basename ${EXEC%.sh}) ${EXEC}; done
