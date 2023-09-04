#!/bin/bash
#---------------------------------------
# yb_minify.sh | minifies src/yb_dev to produce /yb
#---------------------------------------

# Set the eu flag
set -eu

yb::dist(){
  local version_number="0.8"
  ./src/tools/build.sh "${version_number}"
  ./src/tools/minify.sh "${version_number}"
}

yb::dist

# Unset the eu flag
set +eu