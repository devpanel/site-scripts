#!/bin/bash
#
# This script runs a siege benchmark test on the target site

usage() {
  local prog=$(basename "$0")

  echo "Usage: $prog [options] <site_address>

  Options:
    -t time     duration of the test, in seconds
    -c number   number of simultaneous users to simulate

  This script runs a load test with siege on the specified URL.
"
  exit 1
}

error() {
  local msg="$1"

  echo "Error: $msg" 1>&2
  exit 1
}

# main
[ $# -eq 0 ] && usage

unset n_users n_time site_addr
getopt_flags='t:c:'

# compatibility variables for /scripts page
n_time='@n_time@'
n_users='@n_users@'
site_addr='@site_addr@'

for tmp_var in n_time n_users site_addr; do
  # cleanup all variables above if they start with @
  # this is a way to make it compatible with the /scripts page
  tmp_value=${!tmp_var}
  tmp_value=${tmp_value##@*}
  [ -z "$tmp_value" ] && unset "$tmp_var"
done

while getopts $getopt_flags OPTN; do
  case $OPTN in
    t)
      n_time="$OPTARG"
      ;;
    c)
      n_users="$OPTARG"
      ;;
  esac
done
[ $OPTIND -gt 1 ] && shift $(( $OPTIND - 1 ))
[ -z "$1" ] && usage

site_addr="$1"

while [ -z "$n_time" ]; do
  read -p "For how long to test (e.g. 30S, 3M, 5M)? " n_time
  if ! [[ "$n_time" =~ ^[0-9]+[SM]?$ ]]; then
    echo "Error: invalid time specification" 1>&2
    unset n_time
    continue
  fi
done

while [ -z "$n_users" ]; do
  read -p "How many simulatenous users (e.g.: 50, 100, 200)? " n_users
  if ! [[ "$n_users" =~ ^[0-9]+$ ]]; then
    echo "Error: invalid users specification" 1>&2
    unset n_users
  fi
done

while [ -z "$site_addr" ]; do
  read -p "Site address: " site_addr
done

siege -t "$n_time" -c "$n_users" -b "$site_addr"
