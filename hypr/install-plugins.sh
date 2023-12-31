#!/bin/env bash

# Define an array of GitHub URLs
plugins=(
    "https://github.com/Duckonaut/split-monitor-workspaces"
    "https://github.com/VortexCoyote/hyprfocus"
)

# Iterate through the array and call hyprpm add for each URL
for url in "${plugins[@]}"; do
  hyprpm add "${url}"
done
