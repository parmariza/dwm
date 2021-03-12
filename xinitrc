# Fix java GUI application
export _JAVA_AWT_WM_NONREPARENTING=1 
export AWT_TOOLKIT=MToolkit 
# wmname LG3D

datetime() {
    datetime="$(date +"%a, %b %d %H:%M")"
    echo -e "$datetime"
}

mem() {
    mem=`free | awk '/Mem/ {printf "%d/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
    echo -e "$mem"
}

battery_cat() {
    battery="$(cat /sys/class/power_supply/BAT0/capacity)%"
    echo -e "$battery_cat"
}

battery() {
    battery=`acpi | grep 'Battery 0' | grep -oP '(?<=, )\d+(?=%)'`
    status=`acpi -b | grep 'Battery 0' | sed 's/.*: \([a-zA-Z]*\),.*/\1/gi'`

    if [ "$battery" -le 25 ] && [ "$status" == 'Discharging' ]
    then
        if [ "$battery" -le 15 ]
        then
            echo -e "Battery Very Low, Warning: $battery"
        else
            echo -e "Warning: $battery"
        fi
    elif [ "$status" == 'Charging' ]
    then
        echo -e " $battery"
    else
        echo -e "$battery"
    fi
}

kernel_release() {
    kernel_release="$(uname -r)"
    echo -e "$kernel_release"
}

statusbar() {
    statusbar="$(mem) | $(kernel_release) | <username> | $(battery)% $(datetime) "
    echo -e "$statusbar"
}

# Statusbar loop
while true; do
    xsetroot -name " $(statusbar)"
    sleep 1m
done &

# Wallpaper
# feh --bg-fill <wallpaper-path>
# feh --bg-fill <wallpaper-path>

# Export something
# export BROWSER=/usr/bin/google-chrome-stable
# export EDITOR=nvim

# deleted command
# remove dbus-launch 

# Autostart picom compositor
# <path>

# Run dwm
exec dwm
