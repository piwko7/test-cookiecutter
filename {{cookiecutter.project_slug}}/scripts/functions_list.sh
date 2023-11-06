#!/bin/bash

# Functions List v1.0.1

# Changelog
## v1.0.1
## - Added generation of the others functions with different tiggers than httpTrigger, cosmosDbTrigger, serviceBusTrigger, timerTrigger

# -f Disable filename expansion (globbing).
# -e Exit immediately if returns a non-zero status.
# -u Treat unset variables and parameters other than the special parameters.
# -o Set the option corresponding to option-name.
set -feuo pipefail

if ! command -v jq &>/dev/null; then
  echo "[ERROR] jq could not be found" >&2
  exit 1
fi

EXCLUDE_ARRAY=";"

while getopts "f:o:e:a:" opt; do
  case ${opt} in
  a) # Application
    APPLICATION=${OPTARG}
    ;;
  f) # Folder
    FOLDER=${OPTARG}
    ;;
  o) # Output file
    OUTPUT_FILE=${OPTARG}
    ;;
  e) # Exclude function
    if [[ ${EXCLUDE_ARRAY} == "" ]]; then
      EXCLUDE_ARRAY="${OPTARG};"
    else
      EXCLUDE_ARRAY="${EXCLUDE_ARRAY}${OPTARG};"
    fi
    ;;
  esac
done

echo "${APPLICATION}:" > ${OUTPUT_FILE}
FUNCTIONS=$( find $FOLDER -type f -name "function.json" | sed "s#${FOLDER}##g" | sed "s#function.json##g" | sed "s#/##g" )
ALL_FUNCTIONS=()

i=0

echo -e "  functionsByTriggers:\n    http:" >> ${OUTPUT_FILE}
for ITEM in $FUNCTIONS
do
  if [[ $( grep ${FOLDER}/${ITEM}/function.json -e httpTrigger ) && $( echo $EXCLUDE_ARRAY | grep -c ";${ITEM};" ) == 0 ]]; then
    echo "    - ${ITEM}" >> ${OUTPUT_FILE}
    i=$(( $i+1 ))
    ALL_FUNCTIONS+=(${ITEM})
  fi
done

echo -e "    serviceBus:" >> ${OUTPUT_FILE}
for ITEM in $FUNCTIONS
do
  if [[ $( grep ${FOLDER}/${ITEM}/function.json -e serviceBusTrigger ) && $( echo $EXCLUDE_ARRAY | grep -c ";${ITEM};" ) == 0 ]]; then
    QUEUE_NAME=$( cat ${FOLDER}/${ITEM}/function.json | jq -r '.bindings[] | select((.direction=="in") and (.type=="serviceBusTrigger")) | .queueName' )
    echo -e "      - function:\n        name: ${ITEM}\n        queue: ${QUEUE_NAME/\%RESOURCE_PREFIX\%/}" >> ${OUTPUT_FILE}
    i=$(( $i+1 ))
    ALL_FUNCTIONS+=(${ITEM})
  fi
done

echo -e "    cosmosDB:" >> ${OUTPUT_FILE}
for ITEM in $FUNCTIONS
do
  if [[ $( grep ${FOLDER}/${ITEM}/function.json -e cosmosDBTrigger ) && $( echo $EXCLUDE_ARRAY | grep -c ";${ITEM};" ) == 0 ]]; then
    echo "      - ${ITEM}" >> ${OUTPUT_FILE}
    i=$(( $i+1 ))
    ALL_FUNCTIONS+=(${ITEM})
  fi
done

echo -e "    timer:" >> ${OUTPUT_FILE}
for ITEM in $FUNCTIONS
do
  if [[ $( grep ${FOLDER}/${ITEM}/function.json -e timerTrigger ) && $( echo $EXCLUDE_ARRAY | grep -c ";${ITEM};" ) == 0 ]]; then
    echo "      - ${ITEM}" >> ${OUTPUT_FILE}
    i=$(( $i+1 ))
    ALL_FUNCTIONS+=(${ITEM})
  fi
done

# other Triggers
echo -e "    other:" >> ${OUTPUT_FILE}
for ITEM in $FUNCTIONS
do
  if [[ $( grep ${FOLDER}/${ITEM}/function.json -e 'Trigger' ) && $( echo $EXCLUDE_ARRAY | grep -c ";${ITEM};" ) == 0 ]]; then
    IS_PRESENT=false
    for FUNCTION in "${ALL_FUNCTIONS[@]}"
    do
      if [ "${FUNCTION}" == "${ITEM}" ] ; then
          IS_PRESENT=true
      fi
    done

    if [ $IS_PRESENT == false ]; then
      echo "      - ${ITEM}" >> ${OUTPUT_FILE}
    fi
    i=$(( $i+1 ))
  fi
done
