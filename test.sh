#!/usr/bin/env bash

# Set project root as the working directory
cd "$(dirname "$0")" || exit

PROJECT_DIR="$(realpath ".")"
export PROJECT_DIR
PATH=$PROJECT_DIR:$PATH 
export PATH
SCRIPT_NAME="idk"
export SCRIPT_NAME
export SRC="${PROJECT_DIR}"
export TEST="${PROJECT_DIR}/test"
export BUILD="${PROJECT_DIR}/build"

test/lib/bash_unit/bash_unit test/test*.sh

