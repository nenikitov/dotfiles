#!/usr/bin/env sh

# TODO: Use `awww` instead of `swww` when [issue](https://github.com/NixOS/nixpkgs/issues/459434) gets merged
awww-daemon --namespace "wallpaper" &
awww-daemon --namespace "overview" &
