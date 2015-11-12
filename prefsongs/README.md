# prefsongs
manages the preferred songs list to provide an Extreme-style default subset
ultimately just manages a text file (one "PACK/SONG" path by line)

#### setup
 1. edit prefsongs.sh to set SONGLIST to the path of ITG's preferred songs file

#### usage
###### prefsongs.sh {add,rm} PACK/SONG \[PACK/SONG \[...]]
 1. easiest to use from the Songs/ dir, since tab completion is your friend
 2. redundant adds (and removal of inactive songs) will be ignored

###### pref-in-pack.sh {add,rm} SONG \[SONG \[...]]
 1. like prefsongs.sh, but assumes you are currently in a pack directory
 2. prepends the current directory name (assumed to be a pack name) to each SONG
 3. pref-in-pack.sh must be in same directory as prefsongs.sh