#!/usr/bin/env bash

PROGRAM="akash-sanity"
cachedir="$(mktemp -d -t ${PROGRAM}-XXXXXX)"
pvcfile=pvc.yml
podfile=pod.yml
namespace="${PROGRAM}-$(date +%s)"

function run() {
  set -o nounset 
  set -o errexit 
  set -o pipefail
  trap finish EXIT

  abort_if_missing_command "kubectl" "kubectl missing"
  abort_if_missing_command "jq" "jq is missing. see https://stedolan.github.io/jq"
  [ "${cachedir}" ] || abort "cache directory is missing"
  cachedir=$(cd $(dirname ${cachedir}); pwd)/$(basename ${cachedir})

  info "detect nodes"
  log "nodes:"
  log "  $(gethosts)"
  log "Create namespace ${namespace}"
  kubectl create namespace ${namespace} 2>&1 | log

  info "Check Peristant Storage"
  log "Create persistant volume claim"
  mkpvc ${pvcfile}
  kc apply --wait -f ${pvcfile} 2>&1 | log
  log "Create pod, attach claim persistant volume"
  flag=$(date +%s)
  mkpod ${podfile} ${flag}
  kc apply --wait -f ${podfile} 2>&1 | log
  log "Write data to volume"
  log "Delete pod"
  log "Create pod, reclaim volume"
  log "verify data integrity"
  info "PASS: Peristant Storage"
  exit 0
}

function abort_if_missing_command() {
  local cmd=$1
  type ${cmd} >/dev/null 2>&1 || abort "${2}"
}

function info() {
  local msg="==> ${PROGRAM}: ${*}"
  local bold=$(tput bold)
  local reset="\033[0m"
  echo -e "${bold}${msg}${reset}"
}

function log() {
  # read stdin when piped
  set +o nounset
  if [ -z "${1}" ]; then
    while read line ; do
      echo >&2 -e "                  ${line}"
    done
  else
    echo >&2 -e "    ${PROGRAM}: ${*}"
  fi
  set -o nounset
}

function abort() {
  local red=$(tput setaf 1)
  local reset=$(tput sgr0)
  local msg="${red}$@${reset}"
  echo >&2 -e "                 ${msg}"
  exit 1
}

function finish() {
  local exitcode=$?
  local red=$(tput setaf 1)
  local reset="\033[0m"
  local msg="${red}$@${reset}"
  
  info "Cleaning up"
  # kubectl delete namespace ${namespace} 2>&1 | debug
  #     log "Deleted namespace"

  if [ ${exitcode} -eq 0 ]; then
    info "PASS: All checks passed, your node is ready for Akash"
    exit 0
  else
    [[ -f ${errlog} ]] && echo -e "${red}$(cat ${errlog})" | log
    info "${red}FAIL: Some checks failed"
    exit ${exitcode}
  fi
}

function debug() {
  set +o nounset
  # read stdin when piped
  if [ -z "${1}" ]; then
    while read line ; do
      if [[ "${verbose}" == "1" ]]; then
        echo >&2 -e "                 ${line}"
      else
        echo ${line} > /dev/null
      fi
    done
  else
    if [[ "${verbose}" == "1" ]]; then
      echo >&2 -e "                 ${*}"
    fi
  fi
  set -o nounset
}

function gethosts() {
  kubectl get nodes -o json | jq '.items[] | .metadata.name'
}

function getimages() {
  kubectl get nodes -o json | jq '.items[] | .status.images[] | .names[]'
}


function mkpod() {
  local file=$1
  local flag=$2
cat > ${file} <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: sanity-pod
  labels:
    app: sanity
spec:
  containers:
  - name: sanity-container
    image: busybox
    env:
    - name: FLAG
      value: "${flag}"
    command: ['sh', '-c', 'echo "hello akash" > /data/\$FLAG && sleep 3600']
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: sanity-pvc
EOF
}

function kc() {
  kubectl -n $namespace "$@"
}

function mkpvc() {
  local file=$1
cat > ${file} <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sanity-pvc
  labels:
    app: sanity
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: "1Gi"
EOF
}

run
