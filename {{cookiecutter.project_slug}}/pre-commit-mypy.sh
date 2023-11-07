#!/bin/bash
: 'Due to the fact that pipfiles are located in specific repo azure_functions and app,
there was a problem running mypy in pre-commit.

Solution:
Run custom script for each repo that contains Pipfile.

IMPORTANT! `shared` directory should be verified by mypy in each repo. So cannot be excluded in mypy.ini.

There are some important things:
1. To run pipenv the hook type should be `script`
2. By default hook is runned FEW TIMES parallel with group of files
   For many files it is runned few times with different params
   Example (11 files changed):
   1 run with args: `app/mypy.ini .helm/values.yaml azure_functions/mypy.ini .pre-commit-config.yaml`
   2 run with args:`docker/Dockerfile.fxapp shared/exceptions.py app/handlers/http_exception.py azure_functions/basic_trigger/__init__.py`
   3 run with args: `app/main.py docker/Dockerfile.app pre-commit-mypy.sh`
3. If hook param `require_serial` is set to true, this hook will execute using a SINGLE process instead of in parallel.
4. Script exits if mypy fails for one of repo, so you will see only errors from one repo. If you fix it and run mypy again, you will see errors from another repo.
'

REPOS=()
set -e
for ARG in "$@"; do
    SUBREPO=$(echo "$ARG" | sed "s/\/.*//")
    #To avoid duplicates
    if [[ ! " ${REPOS[@]} " =~ " ${SUBREPO} " ]]; then
      REPOS+=("$SUBREPO")
    fi
done

ROOT=$PWD

for REPO_NAME in "${REPOS[@]}"; do
  ABS_PATH="$ROOT/$REPO_NAME"

  if [ -d "$ABS_PATH" ] && [ -f "$ABS_PATH/Pipfile" ] && $REPO_NAME != "iaac_pulumi" ; then
    cd $ABS_PATH;
    mkdir -p .mypy_cache;

    # Display subrepo path
    echo $ABS_PATH

    # Run mypy for specific subrepo
    pipenv run mypy . --install-types --non-interactive
  fi

done
