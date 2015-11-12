#!/bin/bash

TMP=$(date +/tmp/usbhelper.%s.%N)
OUT=$1

error() { (echo "ERROR: $@" >&2) }

get_usbdevs() { (ls -d /sys/bus/usb/devices/*-* | grep -v ':') }
usbdevs() { (for D in $(get_usbdevs); do echo $(basename ${D}); done) }
prompt() {
  read -rsp "insert [P$1] USB drive, then press any key"$'\n' -n1 key
  ATTEMPTS=5
  while [ ${ATTEMPTS} -gt 0 ]; do
    ATTEMPTS=$((ATTEMPTS - 1))
    sleep 2
    NEW=$(usbdevs | grep -vx -f ${TMP})
    if [ ${NEW} ]; then
      if [ $(echo ${NEW} | wc -w) == 1 ]
      then echo ${NEW} && return 0
      else error 'multiple new devices found' && return 1
      fi
    fi
  done
  error 'no new device found after 5 tries' && return 1
}
bindings() {
  BUS_PORT=$(prompt $1 | tr '-' ' ')
  [ "${BUS_PORT}" ] || return 1
  BUS=$(echo ${BUS_PORT} | awk '{ print $1 }')
  PORT=$(echo ${BUS_PORT} | awk '{ print $2 }')
  tee -a ${OUT} <<[BINDINGS]
MemoryCardUsbBusP$1=${BUS}
MemoryCardUsbLevelP$1=-1
MemoryCardUsbPortP$1=${PORT}
[BINDINGS]
}

usbdevs >${TMP} && bindings 1 && bindings 2
rm ${TMP}