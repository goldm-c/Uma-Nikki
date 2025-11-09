#!/bin/sh
printf '\033c\033]0;%s\a' Uma Nikki
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Uma Nikki movement test.x86_64" "$@"
