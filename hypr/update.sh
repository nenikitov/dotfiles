#!/bin/env bash

if [[ ${#} -eq 0 ]]; then
    # Minimal config
    sudo rm -rf ~/.local/share/hyprload 2> /dev/null
    rm ./hyprland.conf.bak 2> /dev/null
    mv ./hyprland.conf ./hyprland.conf.bak
    cat << EOF > ./hyprland.conf
input {
    numlock_by_default = true
}
misc {
    disable_hyprland_logo = true
}
general {
    gaps_out = 0
}
animations {
    bezier = easeOut,  0.00, 0.50, 0.50, 1.00
    animation = windowsIn, 1, 15, easeOut, popin 0%
}

exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = alacritty --hold -e ./update.sh hyprload
EOF
    # Launch hyprland
    Hyprland >/dev/null &>/dev/null &
elif [[ "${1}" == "restore" ]]; then
    # Restore config
    rm ./hyprland.conf
    mv ./hyprland.conf.bak ./hyprland.conf
    echo "Now you can use Hyprland"
    echo "Just don't forget to run \`hyprctl dispatch hyprload update\` and reload Hyprland"
elif [[ ${1} == "hyprload" ]]; then
    curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash
    echo "Installing"
    sleep 5
    "${0}" restore
    sleep 1
    hyprctl dispatch exit
fi

