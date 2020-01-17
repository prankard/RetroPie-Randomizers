#!/usr/bin/env bash
##############
# ATTENTION! #
##############
# This file has changed (26-March-2017). Now it works as RetroPie scriptmodule.
# Name this file as ~/RetroPie-Setup/scriptmodules/suplementary/joystick-selection.sh
# and then execute the retropie_setup.sh script.
# To install the joystick-selection tool, go to
# Manage packages >> Manage experimental packages >> joystick-selection >> Install from source

readonly PLUGIN_NAME="randomizers"

rp_module_id="randomizers" # can't acces this? huh
rp_module_desc="Allows customizable randomized versions of various roms to your game library"
rp_module_help="Follow the instructions on the dialogs to configure random roms in your library"
rp_module_section="exp"

function depends_randomizers() {
    getDepends "libsdl2-dev"
}

function sources_randomizers() {
    gitPullOrClone "$md_build" "https://github.com/prankard/RetroPie-randomizers.git"
}

function build_randomizers() {
    #gcc "$md_build/jslist.c" -o "$md_build/jslist" $(sdl2-config --cflags --libs)
    echo "line"
    echo "${PLUGIN_NAME}"
}

function install_randomizers() {
    local scriptname="${PLUGIN_NAME}.sh"
    local gamelistxml="$datadir/retropiemenu/gamelist.xml"
    local rpmenu_js_sh="$datadir/retropiemenu/$scriptname"

    ln -sfv "$md_inst/$scriptname" "$rpmenu_js_sh"
    # maybe the user is using a partition that doesn't support symbolic links...
    [[ -L "$rpmenu_js_sh" ]] || cp -v "$md_inst/$scriptname" "$rpmenu_js_sh"

    cp -v "$md_build/icon.png" "$datadir/retropiemenu/icons/${PLUGIN_NAME}.png"

    cp -nv "$configdir/all/emulationstation/gamelists/retropie/gamelist.xml" "$gamelistxml"
    if grep -vq "<path>./$scriptname</path>" "$gamelistxml"; then
        xmlstarlet ed -L -P -s "/gameList" -t elem -n "gameTMP" \
            -s "//gameTMP" -t elem -n path -v "./$scriptname" \
            -s "//gameTMP" -t elem -n name -v "Randomize" \
            -s "//gameTMP" -t elem -n desc -v "Randomize your games for more replay fun" \
            -s "//gameTMP" -t elem -n image -v "./icons/${PLUGIN_NAME}.png" \
            -r "//gameTMP" -v "game" \
            "$gamelistxml"

        # XXX: I don't know why the -P (preserve original formatting) isn't working,
        #      The new xml element for joystick_selection tool are all in only one line.
        #      Then let's format gamelist.xml.
        local tmpxml=$(mktemp)
        xmlstarlet fo -t "$gamelistxml" > "$tmpxml"
        cat "$tmpxml" > "$gamelistxml"
        rm -f "$tmpxml"
    fi

    # needed for proper permissions for gamelist.xml and icons/joystick_selection.png
    chown -R $user:$user "$datadir/retropiemenu"

    md_ret_files=(
        'menu.sh'
        'functions.sh'
        "$scriptname"
    )
}

function remove_randomizers() {
    local scriptname="${PLUGIN_NAME}.sh"
    rm -rfv "$configdir"/*/${PLUGIN_NAME}.cfg "$datadir/retropiemenu/icons/${PLUGIN_NAME}.png" "$datadir/retropiemenu/$scriptname"
    xmlstarlet ed -P -L -d "/gameList/game[contains(path,'$scriptname')]" "$datadir/retropiemenu/gamelist.xml"
}

function gui_randomizers() {
    #bash "$md_inst/${PLUGIN_NAME}.sh"
    bash "$md_inst/menu.sh"
}

