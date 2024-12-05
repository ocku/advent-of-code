#!/bin/sh -eu

{
  [ $# -lt 1 ] || [ ! -f "$1" ]
} && exit 1

input="$1"

print_update_if_ordered() {
  update="$1"
  pages="$(printf "%s" "$update" | tr ',' '|')"
  compiled_rules="$(
    grep -E "($pages)\\|($pages)" "$input" |
      tr '|' ' ' |
      tsort # life saver
  )"

  offset="-1"

  for rule in $compiled_rules; do
    current_offset="${update%%"$rule"*}"
    current_offset="${#current_offset}"

    [ "$offset" = -1 ] && {
      offset="$current_offset"
      continue
    }

    [ "$current_offset" -lt "$offset" ] &&
      return

    offset="$current_offset"
  done

  printf "%s\n" "$update"
}

grep ',' "$input" | while read -r update; do
  print_update_if_ordered "$update"
done | awk -F, '
    {
      print $(int((NF+1)/2))
    }
  ' |
  paste -sd+ - |
  bc # 4578
