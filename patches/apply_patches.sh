#!/bin/bash

# Find all patches recursively, and apply them with git-am to the correct repository

SCRIPT_DIR=$(readlink -f ${0%/*})

cd ${SCRIPT_DIR}
for dir in $(find . -mindepth 1 -type d -links 2); do
    for patch in $(find ${dir} -mindepth 1 -type f -name "*.patch" | sort); do
      echo " --> Applying $patch"
      cd ../../../$(dirname $patch)
      git am ${SCRIPT_DIR}/${patch}
      cd ${SCRIPT_DIR}
    done  
done
