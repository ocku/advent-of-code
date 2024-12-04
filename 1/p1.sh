#!/bin/sh -eu

# heavy inspiration from https://github.com/cgsdev0/advent-of-code/tree/main/2024/day1

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

mkfifo left right

awk '{print $1}' "$1" |
  sort -n >left &

awk '{print $2}' "$1" |
  sort -n >right &

paste -d'-' left right |
  bc |
  tr -d '-' |
  paste -sd+ - |
  bc # 3508942

rm left right
