#!/bin/sh -eu

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

nproc=$(nproc 2>/dev/null || sysctl -n hw.logicalcpu)

xargs -P"$nproc" -I{} ./is_valid.sh '{}' 2 \; <"$1" |
  paste -sd+ - |
  bc # 663613490587
