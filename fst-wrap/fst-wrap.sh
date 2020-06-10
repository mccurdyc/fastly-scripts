#!/bin/bash

function fst-usage {
    printf 'Usage:\n\tfst-wrap <pattern> <fastly-command> ["latest"] ["random"]\n'
    return 0
}

function fst-run-cmd {
  svc_name="$(echo "$1" | awk -F '\\s\\s+' '{print $1}')"
  id="$(echo "$1" | awk -F '\\s\\s+' '{print $2}')"
  version="$(echo "$1" | awk -F '\\s\\s+' '{print $4}')"

  cmd="fastly $2 --service-id $id"

  if [[ "$3" == "latest" || "$4" == "latest" ]]; then
    if [ "$version" == "n/a" ]; then
      printf "\n\tSkipping. Latest version is 'n/a'.\n\n"
      return
    fi
    cmd="$cmd --version $version"
  fi

  if [[ "$3" == "random" || "$4" == "random" ]]; then
    random="$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)"
    cmd="$(echo "$cmd" | sed "s/{{ random }}/$random/g")"
  fi

  printf "\n\t$cmd\n\n"
  read -p "Continue? [y/n]: " -r cont

  if [ "$cont" == "y" ]; then
    out=$($cmd)
    echo "$out"
  fi

  printf "\n"
}

function fst-wrap-run {
  while read -r -u 3 svc; do
    if [[ "$1" == "" || "$2" == "" ]]; then
      fst-usage
      return 0
    fi

    if echo "$svc" | grep -q -v "$1"; then
      continue
    fi

    svc_name="$(echo "$svc" | awk -F '\\s\\s+' '{print $1}')"
    echo "Apply to Fastly Service: $svc_name"
    fst-run-cmd "$svc" "$2" "$3" "$4"

  done 3< <(fastly service list | tail -n +2)
}
