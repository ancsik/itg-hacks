#!/bin/bash

# config
coalesce() { (for X in $@; do [ ${X} ] && echo ${X} && return 0; done; return 1) }
SYMBIN_DIR=$(coalesce "$1" "${HOME}/sym-bin")
mkdir -p ${SYMBIN_DIR}

# make sure there is a .bashrc
BASHRC_PATH="${HOME}/.bashrc"
if ! [ -f ${BASHRC_PATH} ]; then echo '#!/bin/bash' > ${BASHRC_PATH}; fi

# add symbin to .bashrc
cat >> ${BASHRC_PATH} <<[BASHRC]

###  [symbin]  ###
export SYMBIN_DIR=\'${SYMBIN_DIR}\'
export PATH="\${SYMBIN_DIR}:\${PATH}"
###  [symbin]  ###

[BASHRC]

# apply changes
. ${BASHRC_PATH}

# install symbin itself
DIR=$(dirname $(readlink -f $0))
${DIR}/symbin.sh "${DIR}/symbin.sh" "${DIR}/symbin-rm.sh"
