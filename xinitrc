# Fix java GUI application
export _JAVA_AWT_WM_NONREPARENTING=1 
export AWT_TOOLKIT=MToolkit 
# wmname LG3D

datetime() {
    local DATETIME="$(date +"%a %b %d %H:%M")"
    echo " ${DATETIME}"
}

mem() {
    local MEM=$(free -m | awk '/Mem/ {printf "%d/%d MiB\n", $3, $2}')
    echo " ${MEM}"
}

battery() {
    local BATTERY=$(acpi -b | awk '/Battery 0/ {print substr($4, 1, length($4) - 2)}')
    local STATUS=$(acpi -b | awk '/Battery 0/ {print substr($3, 1, length($3) - 1)}')

    if [[ "${BATTERY}" -le 25 ]] && [[ "${STATUS}" = 'Discharging' ]]
    then

        if [[ "${BATTERY}" -le 15 ]]
        then
            echo "Battery Very Low, Warning:  ${BATTERY}"
            notify-send -u critical -t 15000 " Battery under 15%" "You need to plug the power adapter into your computer"
        else
            echo "Warning:  ${BATTERY}"
            notify-send " Battery under 25%"
        fi

    elif [[ "${STATUS}" = 'Charging' ]]
    then

        if [[ "$BATTERY" -ge 94 ]]
        then
            echo " ${BATTERY}"
            notify-send -u low  -t 15000 " Fully Charged" "Today at $(date +%H:%M)"
        else
            echo " ${BATTERY}"
        fi

    else

        INDICATOR=" "
        if [[ "${BATTERY}" -lt 25 ]]
        then
            INDICATOR=" "
        elif [[ "${STATUS}" -lt 50 ]]
        then
            INDICATOR=" "
        fi

        echo "${INDICATOR} ${BATTERY}"
    fi
}

kernel_release() {
    local KERNEL_RELEASE=" $(uname -r | sed 's/arch/linux/')"
    echo "${KERNEL_RELEASE}"
}

keyboard_battery() {
    KEYBOARD_ON=$(upower -i /org/freedesktop/UPower/devices/keyboard_hid_dco2co26of8oebob9_battery | grep model)

    if [[ "${?}" -ne 0 ]]
    then
        exit 1
    fi

    KEYBATT=$(upower -i /org/freedesktop/UPower/devices/keyboard_hid_dco2co26of8oebob9_battery | awk '/percentage/ {print substr($2, 0, 2)}')

    if [[ "${KEYBATT}" -le 15 ]]
    then
        notify-send -u critical -t 5000 " Keyboard Batteries Low (${KEYBATT}%)" "Recharge the batteries soon."
    fi
}

statusbar() {
    local STATUSBAR="$(mem) $(kernel_release)  Parma $(battery)% $(datetime) "
    echo "${STATUSBAR}"
}

# Statusbar loop
while [[ true ]]
do
    xsetroot -name " $(statusbar)"
    keyboard_battery
    sleep 1m
done &

# Wallpaper
feh --bg-fill ~/Pictures/Wallpapers/alexandra-nicolae-MKXyRm-pK50-unsplash.jpg
# feh --bg-fill ~/Riza/wallpapers_dwt1/0305.jpg

# deleted command
# remove dbus-launch 

# execute dwm
exec dwm
