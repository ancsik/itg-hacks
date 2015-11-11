# cacheclear
clear chart cache by pack or song to save cache rebuild time

usage:
 1. entire pack: cacheclear.sh PACK
 2. single song: cacheclear.sh PACK SONG

cacheclear matches audio files (mp3 or ogg) to cached charts:
 1. other formats currently unsupported
 2. false positives (using the same audio filename in a different pack) will be deleted and recached