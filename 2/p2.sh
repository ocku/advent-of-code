#!/bin/sh -eu
# this is terribly slow

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

. common.sh

check_dampened_report() {
  filter="$(seq 1 "$#" | paste -sd, -)" #1,2,3,4,...

  for i in $(seq 1 "$#"); do
    # remove $i from the filter and delete extra commas
    iter_filter="$(
      printf "%s" "$filter" |
        sed -E "s/$i//; s/,{2,}/,/; s/^,|,\$//"
    )"

    # build report excluding the i-th level
    iter_level=$(printf "%s " "$@" | cut -d' ' -f"$iter_filter")

    # shellcheck disable=SC2086
    check_report $iter_level &&
      return 0

  done

  return 1
}

ok=0

while read -r line; do
  # shellcheck disable=SC2086
  check_dampened_report $line && ok=$((ok + 1))
done <"$1"

printf "%d\n" "$ok" # 293
