#!/bin/bash

function deactivate {
  svc_name="$(echo "$1" | awk -F '\\s\\s+' '{print $1}')"
  id="$(echo "$1" | awk -F '\\s\\s+' '{print $2}')"
  version="$(echo "$1" | awk -F '\\s\\s+' '{print $4}')"

  if [ "$version" == "n/a" ]; then
    printf "\n\t '$svc_name' not active. Skipping.\n\n"
    return
  fi

  fastly service-version deactivate --service-id "$id" --version "$version"
  printf "\n"
}

function delete {
  id="$(echo "$1" | awk -F '\\s\\s+' '{print $2}')"

  fastly service delete --service-id "$id"
  printf "\n"
}

while read -r -u 3 svc; do
  if echo "$svc" | grep -q -v "$1"; then
    continue
  fi

  svc_name="$(echo "$svc" | awk -F '\\s\\s+' '{print $1}')"
  echo "Deactivate Fastly Service: $svc_name"
  read -p "Continue? [y/n]: " -r deact
  if [ "$deact" == "y" ]; then
    deactivate "$svc"
  fi

  echo "Delete Fastly Service: $svc_name"
  read -p "Continue? [y/n]: " -r del
  if [ "$del" == "y" ]; then
    delete "$svc"
  fi
done 3< <(fastly service list | tail -n +2)
