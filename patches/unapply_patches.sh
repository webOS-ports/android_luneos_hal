#!/bin/bash

# Find all patches recursively, and unapply them with git --reset --hard in the correct repository

SCRIPT_DIR=$(readlink -f ${0%/*})

cd ${SCRIPT_DIR}
for dir in $(find . -mindepth 1 -type d -links 2); do
    for patch in $(find ${dir} -mindepth 1 -type f -name "*.patch" | sort -r); do
      echo " --> Un-applying $patch"
      cd ../../../$(dirname $patch)
      git reset --hard HEAD^
      cd ${SCRIPT_DIR}
    done  
done
