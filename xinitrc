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

battery() {
    battery="$(cat /sys/class/power_supply/BAT0/capacity)%"
    echo -e "$battery"
}

battery2() {
	battery2=`acpi | grep 'Battery 0' | grep -oP '(?<=, )\d+(?=%)'`

	if [ "$battery2" -le 25 ]
	then
		echo -e "Warning: $battery2"
	else
		echo -e "$battery2"
	fi
}

kernel_release() {
    kernel_release="$(uname -r)"
    echo -e "$kernel_release"
}

statusbar() {
    statusbar="$(mem) | $(kernel_release) | Parma | $(battery2)% $(datetime) "
    echo -e "$statusbar"
}

# Statusbar loop
while true; do
    xsetroot -name " $(statusbar)"
    sleep 1m
done &

# Wallpaper
# set wallpaper using
# feh --bg-scale <path-to-image-file>

# Autostart picom
# create autostart if want to use picom
# add path to picom autostart

# Run dwm
exec dwm
