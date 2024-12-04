#!/bin/sh

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

grep -Eo "mul\(\d+,\d+\)" "$1" |
  tr -d 'mul()' | tr ',' '*' |
  paste -sd+ - |
  bc # 187833789
