#!/bin/sh -eu
# this is terribly slow btw

# heavy inspiration from https://github.com/cgsdev0/advent-of-code/tree/main/2024/day1

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

# shellcheck disable=SC2016
awk '{print $1}' "$1" |
  xargs -P8 -I{} /bin/sh -c \
    'printf "%s*%s\n" "{}" "$(grep -cw "\s{}" input)"' |
  # ^ the \s makes it so that only the right column matches
  paste -sd+ - |
  bc # 26593248
