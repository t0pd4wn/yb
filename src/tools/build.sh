#!/bin/bash
#---------------------------------------
# yb_minify.sh | minifies src/yb_dev to produce /yb
#---------------------------------------

# Set the eu flag
set -eu

yb::build(){
  local version_number="${1-}"
  local timestamp="${2-}"
  local copy_file=src/yb_dev_copy
  local help_file=src/yb_help_copy
  local dest_file="dist/yb.${version_number}_${timestamp}"
  local cached_file

  cp src/yb.dev "${copy_file}"
  cp src/yb.help "${help_file}"

  # add dependencies
  source "${help_file}"
  rm "${help_file}"
  help_function=$(declare -f yb::main::help)
  help_function=${help_function//    /  }
  help_function=${help_function//dev version/version "${version_number}-${timestamp}"}

  # remove file header
  sed -i '1,12d;' "${copy_file}"
  # remove empty lines
  sed -i '/^[[:blank:]]*$/ d' "${copy_file}"
  # remove trailing spaces
  sed -i 's/[[:space:]]*$//' "${copy_file}"

  # set file into a variable
  cached_file=$(< "${copy_file}")

  # rm original file
  rm "${copy_file}"
 
  # prepare destination file
  echo "#!/bin/bash" >> "${copy_file}"
  echo "#---------------------------------------" >> "${copy_file}"
  echo "# yb | yaml bash parser | ${version_number}-${timestamp} | Licensed under GNU GPL V3" >> "${copy_file}"
  echo "#---------------------------------------" >> "${copy_file}"
  echo "# Note: this is an automatically built version. The full code is available in the 'src/' folder." >> "${copy_file}"
  echo "#---------------------------------------" >> "${copy_file}"
  echo "set -eu" >> "${copy_file}"
  echo "########################################" >> "${copy_file}"
  echo "# Print the help message" >> "${copy_file}"
  echo "########################################" >> "${copy_file}"
  echo "${help_function}" >> "${copy_file}"

  # loop through each line of the YAML object
  while IFS= read -r line; do
    echo "${line}" >> "${copy_file}"
  done <<< "${cached_file}"

  # chmod file
  chmod +x "${copy_file}"

  # run tests
  if ! ./tests/tests.sh "${copy_file}"; then
    echo "Tests failed"
    exit 1
  else
    # remove previous builds
    rm dist/*
    # copy to root destination
    cp "${copy_file}" yb
    # copy to /dist/ destination
    cp "${copy_file}" "${dest_file}"
    # remove temp file
    rm "${copy_file}"
  fi
}

yb::build "${@}"

# Unset the eu flag
set +eu