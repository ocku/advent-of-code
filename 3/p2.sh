#!/bin/sh

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

grep -Eo "mul\(\d+,\d+\)|do\(\)|don't\(\)" "$1" |
  tr -d "'mul()" | tr ',' '*' |
  awk '
    BEGIN     { skip=0 }
    /^dont$/  { skip=1 }
    /^do$/    { skip=0; next }
    !skip     { print }
  ' |
  paste -sd+ - |
  bc # 94455185
