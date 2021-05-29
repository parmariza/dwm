# Fix java GUI application
export _JAVA_AWT_WM_NONREPARENTING=1 
export AWT_TOOLKIT=MToolkit 
# wmname LG3D

datetime() {
    local DATETIME="$(date +" %a %b %d  %H:%M")"
    echo "${DATETIME}"
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
            echo "Battery Very Low, Warning:   ${BATTERY}"
            notify-send -u critical -t 15000 " Battery under 15%" "You need to plug the power adapter into your computer"
        else
            echo "Warning:   ${BATTERY}"
            notify-send " Battery under 25%"
        fi

    elif [[ "${STATUS}" = 'Charging' ]]
    then

        if [[ "${BATTERY}" -le 30 ]]
        then
            local CHARGE_ICON=''
        elif [[ "${BATTERY}" -le 50  ]]
        then
            local CHARGE_ICON=''
        elif [[ "${BATTERY}" -le 70 ]]
        then
            local CHARGE_ICON=''
        elif [[ "${BATTERY}" -lt 94 ]]
        then
            local CHARGE_ICON=''
        elif [[ "${BATTERY}" -ge 94 ]]
        then
            local CHARGE_ICON=''
            notify-send -u low  -t 15000 " Fully Charged" "Today at $(date +%H:%M)"
        fi

        echo "${CHARGE_ICON} ${BATTERY}"

    else

        local CHARGE_ICON=' '
    
        if [[ "${BATTERY}" -le 35 ]] && [[ "${BATTERY}" -gt 25 ]]
        then
            local CHARGE_ICON=' '
        elif [[ "${BATTERY}" -le 65 ]]
        then
            local CHARGE_ICON=' '
        elif [[ "${BATTERY}" -le 85 ]]
        then
            local CHARGE_ICON=' '
        fi

        echo "${CHARGE_ICON} ${BATTERY}"
    fi
}

get_volume() {
    local GET_VOL=$(pamixer --get-volume)
    local IS_MUTE=$(pamixer --get-mute)

    if [[ "${IS_MUTE}" = 'false' ]]
    then

        if [[ "${GET_VOL}" -le 30 ]]
        then
            local VOL_ICON=' '
        elif [[ "${GET_VOL}" -le 75 ]]
        then
             local VOL_ICON='墳 '
        elif [[ "${GET_VOL}" -gt 75 ]]
        then
            local VOL_ICON=' '
        fi

        echo "${VOL_ICON}${GET_VOL}%"

    else
        local VOL_ICON='婢 '
        local GET_VOL='muted'
        echo "${VOL_ICON}${GET_VOL}"
    fi
}

kernel_release() {
    local KERNEL_RELEASE=" $(uname -r | sed 's/arch/linux/')"
    echo "${KERNEL_RELEASE}"
}

keyboard_battery() {
    KEYBOARD_ON=$(upower -i /org/freedesktop/UPower/devices/keyboard_hid_dco2co26of8oebob9_battery | grep model)

    if [[ "${?}" -eq 0 ]]
    then
    KEYBATT=$(upower -i /org/freedesktop/UPower/devices/keyboard_hid_dco2co26of8oebob9_battery | awk '/percentage/ {print substr($2, 0, 2)}')

        if [[ "${KEYBATT}" -le 15 ]]
        then
            notify-send -u critical -t 5000 " Keyboard Batteries Low (${KEYBATT}%)" "Recharge the batteries soon."
        fi
    fi
}


statusbar() {
    local STATUSBAR="$(mem) $(kernel_release)  NAME $(battery)% $(get_volume) $(datetime) "
    echo "${STATUSBAR}"
}

# Statusbar loop
while [[ true ]]
do
    xsetroot -name " $(statusbar)"
    # keyboard_battery
    sleep 1m
done &

# Wallpaper
# feh --bg-fill ~/Pictures/Wallpapers/christopher-padilla-KL98S4b33rI-unsplash.jpg
# feh --bg-fill ~/Riza/wallpapers_dwt1/0305.jpg

# commented command
# remove dbus-launch 

# execute dwm
exec dwm
