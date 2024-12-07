#!/bin/sh

evaluate() {
  result=""
  equation="$1"
  while [ -n "$equation" ]; do

    [ -z "$result" ] && {
      result="${equation%%[+*|]*}"
      equation="${equation#"$result"}"
      continue
    }

    operator="${equation%"${equation#?}"}"
    next="${equation#"${operator}"}"
    next="${next%%[+*|]*}"

    case "$operator" in
    +) result=$((result + next)) ;;
    \*) result=$((result * next)) ;;
    \|) result="$result$next" ;;
    esac

    equation="${equation#"$operator$next"}"
  done

  printf "%s" "$result"
}

craft_equation() {
  printf "%s\n" "$1" | awk -v operators="$2" '
    {
      split($0, arr_numbers, " ");
      split(operators, arr_operators, " ");
      result = "";

      len = length(arr_numbers)
      for (i = 1; i <= len; i++)
        result = result arr_numbers[i] arr_operators[i];

      print result
    }
  '
}

line="$1"
base="$2"
expected="${line%%:*}"
numbers="${line##*:[[:space:]]}"

spaces="$(printf "%s" "$numbers" | wc -w)"
spaces=$((spaces - 1))
operators=""

i=0
while :; do
  operators="$(
    printf "%0*d\n" "$spaces" \
      "$(printf "obase=$base; %d" "$i" | bc)" |
      tr '0' '+' |
      tr '1' '*' |
      tr '2' '|'
  )"

  [ "${#operators}" -gt "$spaces" ] &&
    break

  # shellcheck disable=SC2086
  operators="$(printf "%s" "$operators" | sed 's/./& /g')"
  equation="$(craft_equation "$numbers" "$operators")"

  printf "%s ?= %s\n" "$equation" "$expected" >&2
  [ "$(evaluate "$equation")" = "$expected" ] && {
    printf "%d\n" "$expected"
    exit
  }

  i=$((i + 1))
done
