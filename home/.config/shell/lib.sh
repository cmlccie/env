# shellcheck shell=sh
# POSIX shell helpers. Sourced by every shell, including dash. No bashisms, no arrays.

have() { command -v "$1" >/dev/null 2>&1; }

source_if() { [ -r "$1" ] && . "$1"; }

path_remove() { case ":$PATH:" in *":$1:"*) PATH="$(printf %s "$PATH" | tr ':' '\n' | grep -vxF "$1" | paste -sd: -)" ;; esac; }

path_prepend() { [ -d "$1" ] || return 0; path_remove "$1"; PATH="$1${PATH:+:$PATH}"; }

path_append() { [ -d "$1" ] || return 0; path_remove "$1"; PATH="${PATH:+$PATH:}$1"; }
