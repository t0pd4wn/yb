#!/bin/bash
#---------------------------------------
# yb_minify.sh | minifies src/yb_dev to produce /yb
#---------------------------------------

# Set the eu flag
set -eu

yb::build(){
  local version_number="${1-}"
  local copy_file=src/yb_dev_copy
  local help_file=src/yb_help_copy
  local cached_file

  cp src/yb.dev "${copy_file}"
  cp src/yb.help "${help_file}"

  # add dependencies
  source "${help_file}"
  rm "${help_file}"
  help_function=$(declare -f yb::main::help)
  help_function=${help_function//    /  }

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
  echo "# yb | yaml bash parser | ${version_number} | Licensed under GNU GPL V3" >> "${copy_file}"
  echo "#---------------------------------------" >> "${copy_file}"
  echo "# Note: this is an automatically built version. The full code is available in 'src/yb_dev'." >> "${copy_file}"
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

  # copy to destination
  cp "${copy_file}" yb

  rm "${copy_file}"

  # run tests
  ./tests/yb_tests.sh "yb"
}

yb::build

# Unset the eu flag
set +eu