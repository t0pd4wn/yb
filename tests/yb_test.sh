#!/bin/bash
#---------------------------------------
# yb_tests | tests for yb
#---------------------------------------

tests(){

	echo -e "\U1F3B2 Welcome to YB tests: "
  echo -e "\U1F4AC PART 1 - Parsing "

	echo -e "\U1F4AC Test 1.0: parse without options"
	parse=$(./yb)
	check_test "No parameters provided" "${parse}"

	echo -e "\U1F4AC Test 1.1: parse without an existing file"
	parse=$(./yb "not_a_file")
	check_test "YAML file needs to be provided through the '-f' option." "${parse}"
	
	echo -e "\U1F4AC Test 1.2: parse file with key selection without options"
	parse=$(./yb tests/yb.yaml "y")
	check_test "b" "${parse}"

	echo -e "\U1F4AC Test 1.3: parse file with key selection with options"
	parse=$(./yb -f tests/yb.yaml -k "y")
	check_test "b" "${parse}"

	echo -e "\U1F4AC Test 1.4: parse file with key chain"
	parse=$(./yb -f tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.5: parse file with key chain, targetting an inline key"
	parse=$(./yb -f tests/yb.yaml -k "yaml.yaml.bash.IFS")
	check_test "BASED PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.6: parse file with key chain, targetting a key with a space"
	parse=$(./yb -f tests/yb.yaml -k "complex.strings.I am")
	check_test "a complex string" "${parse}"

	echo -e "\U1F4AC Test 1.7: parse file with key chain and raw option"
	parse=$(./yb -Rf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.8: parse file with a number output"
	parse=$(./yb -Rf tests/yb.yaml -k "yaml.yaml.yaml.bash.IFS.BASED.number")
	check_test "101" "${parse}"

	echo -e "\U1F4AC Test 1.9: parse file with a boolean output"
	parse=$(./yb -Af tests/yb.yaml -k "is.a.boolean")
	check_test "true" "${parse}"

  echo -e "\U1F4AC Test 1.10: parse file with raw option and depth option"
	parse=$(./yb -Rdf tests/yb.yaml -k "yb.yaml.bash")
	check_test "      - IFS
      - BASED
      - PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.11: parse file with key chain and formatting"
	parse=$(./yb -Ff tests/yb.yaml -k "yb.yaml.bash")
	check_test ".bash_- IFS
.bash_- BASED
.bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.12: parse file with formatting and depth"
  parse=$(./yb -Fdf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_- IFS
....bash_- BASED
....bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.13: parse file with key chain and array option"
  parse=$(./yb -Af tests/yb.yaml -k "yb.yaml.bash")
  check_test "IFS BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.14: parse file with key chain format and array options"
	parse=$(./yb -FAf tests/yb.yaml -k "yb.yaml.bash")
	check_test ".bash_IFS .bash_BASED .bash_PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.15: parse file with formatting, array and depth"
  parse=$(./yb -FAdf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_IFS ....bash_BASED ....bash_PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.16: parse file with all -lLn outer options"
	parse=$(./yb -RlLnf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS{{line}}{{3}}{{6}}
- BASED{{line}}{{3}}{{7}}
- PARSER{{line}}{{3}}{{8}}" "${parse}"

  echo -e "\U1F4AC Test 1.17: parse file with all options but depth"
  parse=$(./yb -FARlLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test ".bash_IFS{{line}}{{3}}{{6}} .bash_BASED{{line}}{{3}}{{7}} .bash_PARSER{{line}}{{3}}{{8}}" "${parse}"
        
  echo -e "\U1F4AC Test 1.18: parse file with all compatible options"
  parse=$(./yb -FARldLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_IFS{{line}}{{3}}{{6}} ....bash_BASED{{line}}{{3}}{{7}} ....bash_PARSER{{line}}{{3}}{{8}}" "${parse}"

  echo -e "\U1F4AC PART 2 - Querying "

  echo -e "\U1F4AC Test 2.1: query for a non-existing key"
  
  parse=$(./yb -qf tests/yb.yaml -k "do.exist.not")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.2: query for an existing key"
  
  parse=$(./yb -qf tests/yb.yaml -k "do.exist")
  check_test "true" "${parse}"

  echo -e "\U1F4AC PART 3 - Addition "

  echo -e "\U1F4AC Test 3.1: add existing key"
  # should be improved to retrieve error code
  parse=$(./yb -af tests/yb.yaml -k "do.exist")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 3.2: add non-existing key"
  ./yb -af tests/yb.yaml -k "never.existed.before"
  parse=$(./yb -qf tests/yb.yaml -k "never.existed.before")

  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.3: add partially-existing key"
  ./yb -af tests/yb.yaml -k "do.exist.not"
  parse=$(./yb -qf tests/yb.yaml -k "do.exist.not")

  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.4: add inline value to an empty existing key"
  ./yb -af tests/yb.yaml -k "do.exist.not" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist.not")

  check_test "false
false" "${parse}"

  echo -e "\U1F4AC Test 3.5: add inline value to a non-empty existing key"
  ./yb -af tests/yb.yaml -k "do.exist.not" -v "true"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist.not")

  check_test "false true
false true" "${parse}"

  echo -e "\U1F4AC Test 3.6: add inline value to a non-existing key with a space"
  ./yb -af tests/yb.yaml -k "did not.exist.before" -v "true"
  parse=$(./yb -Rf tests/yb.yaml -k "did not.exist.before")

  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.7: add list value to a non-existing key"
  ./yb -af tests/yb.yaml -k "list.which.do.exist" -v "- true"
  parse=$(./yb -Rf tests/yb.yaml -k "list.which.do.exist")

  check_test "- true" "${parse}"

  echo -e "\U1F4AC Test 3.8: add multiple list values to an existing key"
  ./yb -af tests/yb.yaml -k "list.which.do.exist" -v "- yes - right"
  parse=$(./yb -Rf tests/yb.yaml -k "list.which.do.exist")

  check_test "- right
- yes
- true" "${parse}"

	
  echo -e "\U1F4AC PART 4 - Removal "

  echo -e "\U1F4AC Test 4.1: remove non existing key"
  parse=$(./yb -rf tests/yb.yaml -k "non.existing.key")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 4.2: remove existing keys"
  ./yb -rf tests/yb.yaml -k "never"
  ./yb -rf tests/yb.yaml -k "do.exist.not"
  ./yb -rf tests/yb.yaml -k "did not"
  ./yb -rf tests/yb.yaml -k "list"
  # parse=$(./yb -rf tests/yb.yaml -k "do.exist.not")
  check_test "" "${parse}"

  # if [[ "${error_code}" -eq 0 ]]; then
  # 	# clean yaml file
	#   sed -i '84,86d' tests/yb.yaml
  # fi

  # end message
  echo ""
  echo "End of yb tests:"
  echo "Tests passed: ${passed_num}"
  echo "Total tests: ${total_num}"
}

check_test(){
	local assertion="${1-}"
	local result="${2-}"

	if [[ "${result}" == "${assertion}" ]]; then
		echo -e "\033[1;36mPassed\033[0m"
		((passed_num++))
		error_code=0
	else
		echo -e "\033[1;33mFailed\033[0m"
		error_code=1
	fi
	((total_num++))
}

clean(){
	if [[ "${error_code}" -eq 0 ]]; then
  	# clean yaml file
	  sed -i '39,39d' tests/yb.yaml
	  sed -i '43,43d' tests/yb.yaml
	  sed -i '85,98d' tests/yb.yaml
  fi
}

globals(){
	declare -g total_num=0
	declare -g passed_num=0
	declare -g error_code
}

main(){
	globals
	time tests
	# clean
}

main