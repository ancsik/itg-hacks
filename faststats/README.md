# faststats
symlinks plus inotifywait polling to reduce the end-of-set I/O delay
 1. faststats symlinks MachineProfile to /tmp, populated from a real MachineProfile directory on disk
 2. faststats watches (via inotifywait) for a change to stats.xml
 3. ITG writes stats.xml[.sig] to tmpfs (i.e. RAM)
 4. faststats detects the write, copies updated stats and signature to disk (as .$FILE.tmp in the real profile dir)
 5. faststats moves (via mv) temp files to proper filenames after all copying completed, old versions are backed up

safe, atomic operations are used for the on-disk overwrite so data corruption should generally be avoided

using faststats will mean that exiting end-of-set save cycle no longer means "immediately safe to shut down" and can cause the loss of the last set's data
