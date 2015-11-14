#!/bin/bash

OUT=$1

error() { (echo "ERROR: $@" >&2) }
do_read() { (read -rsp "$1, then press any key"$'\n' -n1 key) }

USB_BUS='/sys/bus/usb/devices'
GREP='^[0-9][0-9]?-[0-9][0-9]?$'
usbdevs() { (ls ${USB_BUS} | grep -e "${GREP}") }
prompt() {
  do_read "insert [P$1] USB drive"
  ATTEMPTS=5
  while [ ${ATTEMPTS} -gt 0 ]; do
    ATTEMPTS=$((ATTEMPTS - 1))
    NEW=$(usbdevs | grep -v -F "${INIT}")
    if [ ${NEW} ]; then
      if [ $(echo ${NEW} | wc -w) == 1 ]
      then echo ${NEW} && return 0
      else error 'multiple new devices found' && return 1
      fi
    fi
    sleep 2
  done
  error 'no new device found after 5 tries' && return 1
}
bindings() {
  DEV=$(prompt $1)
  [ "${DEV}" ] || return 1
  BNUM=$(cat "${USB_BUS}/busnum")
  PNUM=$(cat "${USB_BUS}/devpath")
  tee -a ${OUT} <<[BINDINGS]
MemoryCardUsbBusP$1=${BNUM}
MemoryCardUsbLevelP$1=-1
MemoryCardUsbPortP$1=${PNUM}
[BINDINGS]
}

do_read "make sure both memory card ports are open"
INIT="$(usbdevs)" && bindings 1 && bindings 2
