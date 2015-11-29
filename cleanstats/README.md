# cleanstats
clean up Stats.xml by deleting stuff that doesn't particularly matter, so it saves/loads faster

#### notes:
 1. this exists to keep old high scores without dealing with long save times at the end of a set,
if you don't particularly care about losing scores, starting fresh is a valid option
 2. Testing against the 10 year old Acme Stats.xml cut the file size by about 40%
 3. Stats.xml.sig will not match the output, but OITG ignores it for MachineProfile anyway

#### usage:
###### cleanstats.sh path/to/MachineProfile/Stats.xml \[> OUTFILE]

#### deleted element types
 1. <CalorieData/>
 2. <CoinData/>
 3. <CoinDataService/>
 4. <Song Dir='@mc{1,2}/...' /> (i.e. scores for custom USB Songs)