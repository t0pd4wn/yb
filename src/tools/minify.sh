#!/bin/bash
#---------------------------------------
# yb_minify.sh | minifies src/yb_dev to produce /yb
#---------------------------------------

# Set the eu flag
set -eu

yb::minify(){
  local version_number="${1-}"
  local copy_file=src/yb_dev_copy
  local help_file=src/yb_help_copy
  local dest_file=dist/yb.min
  local cached_file

  cp src/yb.dev "${copy_file}"
  cp src/yb.help "${help_file}"

  source "${help_file}"

  help_function=$(declare -f yb::main::help)
  help_function=${help_function//    /  }
  help_function=${help_function//dev version/\
minified version "${version_number}"}

  # remove comments
  sed -i '/^[[:blank:]]*#/d' "${copy_file}"
  # sed -i '/^[[:blank:]]*#/d' "${help_file}"
  # remove empty lines
  sed -i '/^[[:blank:]]*$/ d' "${copy_file}"
  # remove trailing spaces
  sed -i 's/[[:space:]]*$//' "${copy_file}"
  # remove leading spaces
  sed -i 's/^[[:space:]]*//' "${copy_file}"

  cached_file=$(< "${copy_file}")

  rm "${copy_file}"

  # remove the help function source
  cached_file="${cached_file//"source src/yb.help"/}"
  cached_file="${cached_file//set -eu/}"

  # replacements
  cached_file="${cached_file//yb/_}"
  cached_file="${cached_file//able/ae}"
  cached_file="${cached_file//and/ad}"
  cached_file="${cached_file//add/a}"
  cached_file="${cached_file//anchor/an}"
  cached_file="${cached_file//append/ap}"
  cached_file="${cached_file//array/ra}"
  cached_file="${cached_file//base/ba}"
  cached_file="${cached_file//boolean/bo}"
  cached_file="${cached_file//build/b}"
  cached_file="${cached_file//change/c}"
  cached_file="${cached_file//cache/ca}"
  cached_file="${cached_file//child/cd}"
  cached_file="${cached_file//clean/cl}"
  cached_file="${cached_file//color/cr}"
  cached_file="${cached_file//copy/co}"
  cached_file="${cached_file//comment/cmt}"
  cached_file="${cached_file//content/cnt}"
  cached_file="${cached_file//core/cr}"
  cached_file="${cached_file//counter/ctr}"
  cached_file="${cached_file//count/ct}"
  cached_file="${cached_file//condition/cn}"
  cached_file="${cached_file//delete/d}"
  cached_file="${cached_file//delimiter/dm}"
  cached_file="${cached_file//depth/de}"
  cached_file="${cached_file//file/f}"
  cached_file="${cached_file//filter/fr}"
  cached_file="${cached_file//first/ft}"
  cached_file="${cached_file//format/fo}"
  cached_file="${cached_file//globals/g}"
  cached_file="${cached_file//has/h}"
  cached_file="${cached_file//help/he}"
  cached_file="${cached_file//index/ix}"
  cached_file="${cached_file//inline/in}"
  cached_file="${cached_file//inclusive/iv}"
  cached_file="${cached_file//is_modified/im}"
  cached_file="${cached_file//is_empty/ie}"
  cached_file="${cached_file//keys/ks}"
  cached_file="${cached_file//key/k}"
  cached_file="${cached_file//_line/_l}"
  cached_file="${cached_file//line_/l_}"
  cached_file="${cached_file//lines_/ls_}"
  # cached_file="${cached_file//line/l}"
  cached_file="${cached_file//level/lv}"
  cached_file="${cached_file//last/lt}"
  cached_file="${cached_file//length/le}"
  cached_file="${cached_file//list/lt}"
  cached_file="${cached_file//lock/lo}"
  cached_file="${cached_file//main/m}"
  cached_file="${cached_file//message/me}"
  cached_file="${cached_file//next/nx}"
  cached_file="${cached_file//number/n}"
  cached_file="${cached_file//object/o}"
  cached_file="${cached_file//option/op}"
  cached_file="${cached_file//output/ot}"
  cached_file="${cached_file//outer/or}"
  cached_file="${cached_file//original/ol}"
  cached_file="${cached_file//parse/p}"
  cached_file="${cached_file//print/pt}"
  cached_file="${cached_file//parent/pa}"
  cached_file="${cached_file//pipe/pi}"
  cached_file="${cached_file//prefix/px}"
  cached_file="${cached_file//prepare/pr}"
  cached_file="${cached_file//previous/pv}"
  cached_file="${cached_file//query/q}"
  cached_file="${cached_file//remove/r}"
  cached_file="${cached_file//raw/rw}"
  cached_file="${cached_file//regex/rx}"
  cached_file="${cached_file//replace/re}"
  cached_file="${cached_file//result/rt}"
  cached_file="${cached_file//retriev/rv}"
  cached_file="${cached_file//search/se}"
  cached_file="${cached_file//spacer/sr}"
  cached_file="${cached_file//spaces/sp}"
  cached_file="${cached_file//spacing/sg}"
  cached_file="${cached_file//separator/spa}"
  cached_file="${cached_file//sequence/s}"
  cached_file="${cached_file//show/sh}"
  # cached_file="${cached_file//space/spc}"
  cached_file="${cached_file//string/st}"
  cached_file="${cached_file//start/sa}"
  cached_file="${cached_file//step/se}"
  cached_file="${cached_file//style/sy}"
  cached_file="${cached_file//suffix/su}"
  cached_file="${cached_file//target/tg}"
  cached_file="${cached_file//temp/t}"
  cached_file="${cached_file//to_append/ta}"
  cached_file="${cached_file//to_delete/td}"
  cached_file="${cached_file//to_file/tf}"
  cached_file="${cached_file//trimmed/tm}"
  cached_file="${cached_file//type/ty}"
  cached_file="${cached_file//update/u}"
  cached_file="${cached_file//value/v}"
  cached_file="${cached_file//yaml/y}"
  cached_file="${cached_file//YAML/Y}"
  cached_file="${cached_file//::manage/::m}"
  cached_file="${cached_file//::space/::sp}"
  cached_file="${cached_file//::hyphen/::hy}"
  cached_file="${cached_file//::set_IFS/::sI}"
  cached_file="${cached_file//::unset_IFS/::uI}"
  cached_file="${cached_file//::trim/::tr}"
  # last removal
  cached_file="${cached_file//ed/d}"
  # cached_file="${cached_file//::/_}"
  cached_file="${cached_file//__/_}"

  # correcting strings
  cached_file="${cached_file//No parameters providd./No parameters provided.}"
  cached_file="${cached_file//See the \'-h\' he op for usage details./See the \'-h\' help option for usage details.}"
  cached_file="${cached_file//Values are nedd when using the \'-c\' op./Values are needed when using the \'-c\' option.}"
  cached_file="${cached_file//A Y f or o neds to be providd/A YAML file or object needs to be provided}"
  cached_file="${cached_file//through the \'-f\' or \'-o\' ops./through the \'-f\' or \'-o\' options.}"
  cached_file="${cached_file//-f f ad -o o can not be usd together./-f file and -o object can not be used together.}"
  cached_file="${cached_file//Use -O to a o v ty to Y f or o./Use -O to add object value type to YAML file or object.}"
  cached_file="${cached_file//File is currently being processd with _./File is currently being processd with yb.}"

  # prepare destination file
  echo "#!/bin/bash" >> "${copy_file}"
  echo "#---------------------------------------" >> "${copy_file}"
  echo "# yb | yaml bash parser | ${version_number} | Licensed under GNU GPL V3" >> "${copy_file}"
  echo "#---------------------------------------" >> "${copy_file}"
  echo "# Note: this is a minified version. The full code is available in 'src/yb_dev'." >> "${copy_file}"
  echo "#---------------------------------------" >> "${copy_file}"
  echo "set -eu" >> "${copy_file}"

  cached_file="${cached_file//_m_he/yb::main::help}"

  echo "${help_function}" >> "${copy_file}"

  # loop through each line of the YAML object
  while IFS= read -r line; do
    echo "${line}" >> "${copy_file}"
  done <<< "${cached_file}"

  # remove empty lines
  sed -i '/^[[:blank:]]*$/ d' "${copy_file}"

  chmod +x "${copy_file}"

  cp "${copy_file}" "${dest_file}"

  rm "${copy_file}"
  rm "${help_file}"

  ./tests/tests.sh "dist/yb.min"
}

yb::minify "${@}"

# Unset the eu flag
set +eu