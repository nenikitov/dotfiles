#!/usr/bin/env sh

IMAGE="${1}"
shift 1

# TODO: Use `awww` instead of `swww` when [issue](https://github.com/NixOS/nixpkgs/issues/459434) gets merged
awww img --namespace "wallpaper" "${IMAGE}" "${@}" &
magick "${IMAGE}" -blur 0x10 - | swww img --namespace "overview" - "${@}" &
