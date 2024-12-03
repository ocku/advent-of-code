#!/bin/sh

check_report() {
  trend=""
  previous=""

  for num in "$@"; do
    [ -z "$previous" ] && {
      previous="$num"
      continue
    }

    iter_diff="$((num - previous))"
    iter_distance="${iter_diff#-}"
    iter_trend="${iter_diff%"$iter_distance"}n"

    [ "$iter_distance" -gt 3 ] ||
      [ "$iter_distance" = 0 ] &&
      return 1

    [ -z "$trend" ] && {
      trend="$iter_trend"
      previous="$num"
      continue
    }

    [ "$iter_trend" != "$trend" ] &&
      return 1

    previous="$num"
  done

  true
}
