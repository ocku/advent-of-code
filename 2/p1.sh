#!/bin/sh -eu

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

. common.sh

ok=0

while read -r line; do
  # shellcheck disable=SC2086
  check_report $line && ok=$((ok + 1))
done <"$1"

printf "%d\n" "$ok" # 224
