#!/bin/bash

[ ${SYMBIN_DIR} ] || (echo "ERROR: run symbin-setup.sh first" && exit 1)

for CMD in $@
do rm -v "${SYMBIN_DIR}/${CMD}"
done
