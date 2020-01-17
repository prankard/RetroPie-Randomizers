#!/bin/bash
source functions.sh
game_config="config.ini"

iniConfig ' = ' '"' '' 1

iniGet git "$game_config"
git=$ini_value
iniGet name "$game_config"
name=$ini_value
iniGet name "$game_config"
name=$ini_value
iniGet game_name "$game_config"
gamename=$ini_value
iniGet systemname "$game_config"
systemname=$ini_value
iniGet romdestination "$game_config"
romdestination=$ini_value

#hasRom "snes" "Super Metroid"
hasRom "$systemname" "$gamename"
if [[ "$?" == "1" ]]; then
#    copyRom "snes" "Super Metroid" "rom.smc"
    copyRom "$systemname" "$gamename" "$romdestination"
    
#    rm -r -f varia
#    mkdir varia
#    git clone --depth 1 "git@github.com:theonlydude/RandomMetroidSolver.git" varia
    rm -r -f "$name"
    mkdir "$name"
    git clone --depth 1 "$git" "$name"
fi