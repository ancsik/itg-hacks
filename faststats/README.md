# faststats
faster score saving at end of set (for when big stats.xml files slow you down)

#### package dependencies
 1. inotify-tools (for inotifywait)

#### usage:
###### edit faststats.sh to set the REAL_DIR/FAKE_DIR paths
 1. mv your MachineProfile to $REAL_DIR
 2. FAKE_DIR should be the original MachineProfile path (faststats creates $FAKE_DIR for you)
 3. use absolute paths for both for simplicity
###### optionally set CLEANSTATS_SH to point to cleanstats.sh
 1. this will switch from direct copying to automatically cleaning Stats.xml on each save

###### in your ITG boot script, run faststats (as bg job: 'faststats.sh&') before starting ITG itself
 1. faststats can handle ITG rebooting
 2. faststats should not need to be killed until system shutdown does it for you
 3. faststats and symbin will not play nicely at boot; use the absolute path in your boot logic

#### how it works
###### symlinks plus inotifywait polling to reduce the end-of-set I/O delay
 1. fs-init symlinks $FAKE_DIR to /tmp, populated from a real MachineProfile directory on disk
 2. fs-loop watches (via inotifywait) for a change to stats.xml
 3. ITG writes stats.xml(.sig) to tmpfs (i.e. RAM)
 4. fs-loop detects the write, copies updated stats and signature to disk (as .$FILE.tmp in the real profile dir)
 5. fs-loop moves (via mv) temp files to correct file names after all copying completed, old versions are backed up with '.bak' suffix

#### design notes
 1. copying to a temporary name on disk and then atomically renaming reduces risk of data corruption
 2. this means the end-of-set saving freeze ends before scores are actually on disk: shutting down right after the game un-freezes may drop the most recent scores
 3. faststats waits for both stats.xml and stats.xml.sig to be written to /tmp before copying to disk: there is risk of them saving out of sync, but it should be minimal

#### test-faststats
 1. runs against /tmp with dummy files
 2. run, then check /tmp/faststats and /tmp/fs-test to see the resulting files
