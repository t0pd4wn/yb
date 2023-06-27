#!/bin/bash
#---------------------------------------
# yb_tests | tests for yb
#---------------------------------------

tests(){
	echo "Welcome to YB tests: "

	echo "-- Test 0 : parse without options"
	parse=$(./yb)
	check_test "No parameters provided" "${parse}"

	echo "-- Test 1 : parse without an existing file"
	parse=$(./yb "not_a_file")
	check_test "YAML file needs to be provided through the '-f' option." "${parse}"
	
	echo "-- Test 2 : parse file with key selection without options"
	parse=$(./yb tests/yb.yaml "y")
	check_test "b" "${parse}"

	echo "-- Test 3 : parse file with key selection with options"
	parse=$(./yb -f tests/yb.yaml -k "y")
	check_test "b" "${parse}"

	echo "-- Test 4 : parse file with key chain and formatting"
	parse=$(./yb -Ff tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER
..- IFS: BASED PARSER" "${parse}"

	echo "-- Test 5 : parse file with key chain and RAW option"
	parse=$(./yb -Rf tests/yb.yaml -k "yb.yaml.bash")
	check_test "       - IFS
       - BASED
       - PARSER
       - IFS: BASED PARSER" "${parse}"

    echo "-- Test 6 : parse file with key chain and Array option"
	parse=$(./yb -FAf tests/yb.yaml -k "yb.yaml.bash")
	check_test "IFS BASED PARSER ..IFS BASED PARSER" "${parse}"
}

check_test(){
	assertion="${1-}"
	result="${2-}"
	if [[ "${result}" == "${assertion}" ]]; then
		echo "Passed"
	else
		echo "Failed"
	fi
}

tests