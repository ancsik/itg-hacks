# usbhelper
figures out usb port config for ITG by having you just plug in a damn USB drive

#### usage:
###### usbhelper.sh \[FILE]
 1. run command with *no drive* plugged in
 2. when prompted, insert drive into P1 USB port and press enter
 3. when prompted, insert drive into P2 USB port and press enter
 4. valid .ini bindings for these two ports will be printed to stdout
 5. the bindings will be saved to FILE (if specified)
 6. edit your ITG settings to match the output

#### sample output (from a desktop)
###### stdout
```
insert [P1] USB drive, then press any key
MemoryCardUsbBusP1=3
MemoryCardUsbLevelP1=-1
MemoryCardUsbPortP1=14
insert [P2] USB drive, then press any key
MemoryCardUsbBusP2=3
MemoryCardUsbLevelP2=-1
MemoryCardUsbPortP2=13
```
###### optional file
```
MemoryCardUsbBusP1=3
MemoryCardUsbLevelP1=-1
MemoryCardUsbPortP1=14
MemoryCardUsbBusP2=3
MemoryCardUsbLevelP2=-1
MemoryCardUsbPortP2=13
```
