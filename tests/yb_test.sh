#!/bin/bash
#---------------------------------------
# yb_tests | tests for yb
#---------------------------------------

tests(){
  globals

	echo -e "\U1F3B2 Welcome to YB tests: "

	echo -e "\U1F4AC Test 0 : parse without options"
	parse=$(./yb)
	check_test "No parameters provided" "${parse}"

	echo -e "\U1F4AC Test 1 : parse without an existing file"
	parse=$(./yb "not_a_file")
	check_test "YAML file needs to be provided through the '-f' option." "${parse}"
	
	echo -e "\U1F4AC Test 2 : parse file with key selection without options"
	parse=$(./yb tests/yb.yaml "y")
	check_test "b" "${parse}"

	echo -e "\U1F4AC Test 3 : parse file with key selection with options"
	parse=$(./yb -f tests/yb.yaml -k "y")
	check_test "b" "${parse}"

	echo -e "\U1F4AC Test 4 : parse file with key chain and raw option"
	parse=$(./yb -Rf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER
- IFS: BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 5 : parse file with raw option and depth option"
	parse=$(./yb -Rdf tests/yb.yaml -k "yb.yaml.bash")
	check_test "      - IFS
      - BASED
      - PARSER
      - IFS: BASED PARSER" "${parse}"

	echo -e "\U1F4AC Test 6 : parse file with key chain and formatting"
	parse=$(./yb -Ff tests/yb.yaml -k "yb.yaml.bash")
	check_test ".bash_- IFS
.bash_- BASED
.bash_- PARSER
.bash_- IFS: BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 7 : parse file with formatting and depth"
  parse=$(./yb -Fdf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_- IFS
....bash_- BASED
....bash_- PARSER
....bash_- IFS: BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 8 : parse file with key chain and array option"
  parse=$(./yb -Af tests/yb.yaml -k "yb.yaml.bash")
  check_test "IFS BASED PARSER IFS_ BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 9 : parse file with key chain and array option"
	parse=$(./yb -FAf tests/yb.yaml -k "yb.yaml.bash")
	check_test ".bash_IFS .bash_BASED .bash_PARSER .bash_IFS_ BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 10 : parse file with formatting, array and depth"
  parse=$(./yb -FAdf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_IFS ....bash_BASED ....bash_PARSER ....bash_IFS_ BASED PARSER" "${parse}"

	echo -e "\U1F4AC Test 11 : parse file with all -lLn outer options"
	parse=$(./yb -RlLnf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS{{line}}{{4}}{{6}}
- BASED{{line}}{{4}}{{7}}
- PARSER{{line}}{{4}}{{8}}
- IFS: BASED PARSER{{line}}{{4}}{{21}}" "${parse}"

  echo -e "\U1F4AC Test 12 : parse file with all options but depth"
  parse=$(./yb -FARlLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test ".bash_IFS{{line}}{{4}}{{6}} .bash_BASED{{line}}{{4}}{{7}} .bash_PARSER{{line}}{{4}}{{8}} .bash_IFS_ BASED PARSER{{line}}{{4}}{{21}}" "${parse}"
        
  echo -e "\U1F4AC Test 13 : parse file with all options"
  parse=$(./yb -FARldLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_IFS{{line}}{{4}}{{6}} ....bash_BASED{{line}}{{4}}{{7}} ....bash_PARSER{{line}}{{4}}{{8}} ....bash_IFS_ BASED PARSER{{line}}{{4}}{{21}}" "${parse}"    

  echo -e "\U1F4AC Test 14 : add existing key"
  ./yb -af tests/yb.yaml -k "yb.yaml.bash"
  parse=$(./yb -f tests/yb.yaml -k "do.exist")
  check_test "- IFS
- BASED
- PARSER
- IFS: BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 14 : add non-existing key"
  ./yb -af tests/yb.yaml -k "yb.yaml.bash"
  parse=$(./yb -f tests/yb.yaml -k "do.not")
  check_test "- IFS
- BASED
- PARSER
- IFS: BASED PARSER" "${parse}"

  # end message
  echo ""
  echo "End of yb tests :"
  echo "Tests passed : ${passed_num}"
  echo "Total tests : ${total_num}"
}

check_test(){
	assertion="${1-}"
	result="${2-}"
	if [[ "${result}" == "${assertion}" ]]; then
		echo -e "\033[1;36mPassed\033[0m"
		((passed_num++))
	else
		echo -e "\033[1;33mFailed\033[0m"
	fi
	((total_num++))
}

globals(){
	declare -g total_num=0
	declare -g passed_num=0
}

time tests