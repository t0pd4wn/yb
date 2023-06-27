#!/bin/bash
#---------------------------------------
# yb_tests | tests for yb
#---------------------------------------

tests(){

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

	echo -e "\U1F4AC Test 4 : parse file with key chain and RAW option"
	parse=$(./yb -Rf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER
- IFS: BASED PARSER" "${parse}"

    echo -e "\U1F4AC Test 5 : parse file with RAW option and depth option"
	parse=$(./yb -Rdf tests/yb.yaml -k "yb.yaml.bash")
	check_test "       - IFS
       - BASED
       - PARSER
       - IFS: BASED PARSER" "${parse}"

	echo -e "\U1F4AC Test 6 : parse file with key chain and formatting"
	parse=$(./yb -Ff tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER
..- IFS: BASED PARSER" "${parse}"

    echo -e "\U1F4AC Test 7 : parse file with key chain and Array option"
	parse=$(./yb -FAf tests/yb.yaml -k "yb.yaml.bash")
	check_test "IFS BASED PARSER ..IFS BASED PARSER" "${parse}"


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

tests