#!/bin/bash
SCRIPT=$(basename "$0")

# Refreshing secret values were solved by creating secret objects with
# a unique name based on the image tag. Every deployment creates a new
# set of secrets. A clean-up script is used to remove secrets that
# are not used anymore.

# -f Disable filename expansion (globbing).
# -e Exit immediately if returns a non-zero status.
# -u Treat unset variables and parameters other than the special parameters.
# -o Set the option corresponding to option-name.
set -feuo pipefail

while getopts "n:a:t:" opt; do
  case ${opt} in
  n)
    NAMESPACE=${OPTARG}
    ;;
  a)
    APPLICATION=${OPTARG}
    ;;
  t)
    TAG=${OPTARG}
    ;;
  *)
    echo "AKS Secrets cleaner:"
    echo "${SCRIPT} [options]"
    echo ""
    echo "-n <name>  [required] Namespace with the application."
    echo "-a <name>  [required] Deployed application name."
    echo "-t <name>  [required] Tagged secret to excluded."
    exit 1
    ;;
  esac
done

secrets=$( kubectl get secrets --field-selector type=Opaque -n ${NAMESPACE} -o=custom-columns='NAME:.metadata.name' | grep "^${APPLICATION}-secrets-" | grep -v "${TAG}" || true )
FILTERED=$( echo $secrets | wc -w | xargs )

if ! [[ -z "$secrets" ]]; then
  for item in $secrets
  do
    kubectl delete secret $item -n ${NAMESPACE}
  done
fi
