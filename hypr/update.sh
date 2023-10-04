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

exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = alacritty --hold -e ./update.sh hyprload
EOF
    # Launch hyprland
    Hyprland >/dev/null &>/dev/null &
elif [[ "${1}" == "restore" ]]; then
    # Restore config
    rm ./hyprland.conf
    mv ./hyprland.conf.bak ./hyprland.conf
elif [[ ${1} == "hyprload" ]]; then
    curl -sSL https://raw.githubusercontent.com/Duckonaut/hyprload/main/install.sh | bash
    "${0}" restore
    sleep 1
    hyprctl dispatch exit
fi

