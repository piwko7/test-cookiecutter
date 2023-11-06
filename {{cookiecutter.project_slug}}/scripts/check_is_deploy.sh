#!/bin/bash
SCRIPT=$(basename "$0")

# Checking if other deployments aren't during processing

# -f Disable filename expansion (globbing).
# -e Exit immediately if returns a non-zero status.
# -u Treat unset variables and parameters other than the special parameters.
# -o Set the option corresponding to option-name.
set -feuo pipefail

while getopts "n:d:" opt; do
  case ${opt} in
  n)
    NAMESPACE=${OPTARG}
    ;;
  d)
    DEPLOYMENT=${OPTARG}
    ;;
  *)
    echo "Helm deployment chceker:"
    echo "${SCRIPT} [options]"
    echo ""
    echo "-n <name>  [required] Namespace with the application."
    echo "-d <name>  [required] Deployment name."
    exit 1
    ;;
  esac
done

function check_status {
  status=$( helm status ${DEPLOYMENT} -n ${NAMESPACE} | grep STATUS | cut -c 9-100 )
  echo $status
}

i=0
status="$(check_status)"

while [[ $status == "pending-upgrade" ]]; do
  sleep 5
  status="$(check_status)"
  echo "Waiting for deployment availability (present is the ${status} status)..."
  i=$((i+1))

  if [[ $i -gt 120 ]]; then
    echo "Helm status is too long in the pending-upgrade status"
    exit 1
  fi
done

echo "Helm installation is available"
