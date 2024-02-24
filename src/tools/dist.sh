#!/bin/bash
#---------------------------------------
# yb_minify.sh | minifies src/yb_dev to produce /yb
#---------------------------------------

# Set the eu flag
set -eu

yb::dist(){
  local version_number="0.9"
  local timestamp=$(date +"%Y%m%d%H%M%S")
  ./src/tools/build.sh "${version_number}" "${timestamp}"
  ./src/tools/minify.sh "${version_number}" "${timestamp}"
  git add -A dist/
  git add yb
  git commit -m "dist: ${version_number} - ${timestamp}"
}

yb::dist

# Unset the eu flag
set +eu