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
	check_test "A YAML file needs to be provided through the '-f' option." "${parse}"
	
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
	parse=$(./yb -f tests/yb.yaml -k "yaml.yaml.bash.- IFS")
	check_test "BASED PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.6: parse file with key chain, targetting an inline-key containing a space"
	parse=$(./yb -f tests/yb.yaml -k "complex.strings.- I am")
	check_test "a complex string" "${parse}"

	echo -e "\U1F4AC Test 1.7: parse file with key chain and raw option"
	parse=$(./yb -Rf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.8: parse file with a number output"
	parse=$(./yb -Rf tests/yb.yaml -k "yaml.yaml.yaml.bash.- IFS.- BASED.number")
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
	check_test "- IFS{{line}}{{3}}{{7}}
- BASED{{line}}{{3}}{{8}}
- PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC Test 1.17: parse file with all options but depth"
  parse=$(./yb -FARlLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test ".bash_IFS{{line}}{{3}}{{7}} .bash_BASED{{line}}{{3}}{{8}} .bash_PARSER{{line}}{{3}}{{9}}" "${parse}"
        
  echo -e "\U1F4AC Test 1.18: parse file with all compatible options"
  parse=$(./yb -Tf tests/yb.yaml -k "yb.yaml.bash")
  check_test "- !! str IFS
- !! str BASED
- !! str PARSER" "${parse}"
  
  echo -e "\U1F4AC Test 1.19: parse file with all compatible options"
  parse=$(./yb -FARTldLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_!! str IFS{{line}}{{3}}{{7}} ....bash_!! str BASED{{line}}{{3}}{{8}} ....bash_!! str PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC PART 2 - Querying "

  echo -e "\U1F4AC Test 2.1: query for a non-existing key"
  
  parse=$(./yb -qf tests/yb.yaml -k "do.exist.not")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.2: query for an existing key"
  
  parse=$(./yb -qf tests/yb.yaml -k "do.exist")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.3: query for a non-existing value"
  
  parse=$(./yb -qf tests/yb.yaml -k "do.exist" -v "Does exist")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.4: query for single existing value"
  
  parse=$(./yb -qf tests/yb.yaml -k "not.to.be.- found" -v "TRUE")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.5: query for multiple existing values"
  
  parse=$(./yb -qf tests/yb.yaml -k "do" -v "true")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.6: query for existing inline value"
  parse=$(./yb -qf tests/yb.yaml -k "yaml.yaml.bash.- IFS" -v "BASED PARSER")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.7: query for existing pipe values"
  parse=$(./yb -qf tests/yb.yaml -k "- ascii|" -v "  ___  _ ____  \  \///  __\   \  / | | //   / /  | |_\\\  /_/   \____/")
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

  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 3.4: add non existing list-key"
  ./yb -af tests/yb.yaml -k "- new"
  parse=$(./yb -qf tests/yb.yaml -k "- new")

  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.5: add partially-existing list-key"
  ./yb -af tests/yb.yaml -k "- new.- child"
  parse=$(./yb -qf tests/yb.yaml -k "- new.- child")

  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.6: add inline value to an empty existing key"
  ./yb -af tests/yb.yaml -k "do.exist.not" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist.not")

  check_test "false
false" "${parse}"

  echo -e "\U1F4AC Test 3.7: add inline value to a non-empty existing key"
  ./yb -af tests/yb.yaml -k "do.exist.not" -v "true"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist.not")

  check_test "false true
false true" "${parse}"

  echo -e "\U1F4AC Test 3.8: add inline value to a non-existing key with a space"
  ./yb -af tests/yb.yaml -k "did not.exist.before" -v "true"
  parse=$(./yb -Rf tests/yb.yaml -k "did not.exist.before")

  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.9: add list value to a non-existing key"
  ./yb -af tests/yb.yaml -k "list.which.do.exist" -v "- true"
  parse=$(./yb -Rf tests/yb.yaml -k "list.which.do.exist")
  check_test "- true" "${parse}"

  echo -e "\U1F4AC Test 3.10: add multiple list values to an existing key"
  ./yb -af tests/yb.yaml -k "list.which.do.exist" -v "- yes - right"
  parse=$(./yb -Rf tests/yb.yaml -k "list.which.do.exist")
  check_test "- yes
- right
- true" "${parse}"

  echo -e "\U1F4AC Test 3.11: add complex inline value to a non existing key"
  ./yb -af tests/yb.yaml -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.'
  parse=$(./yb -qf tests/yb.yaml -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.12: add pipe type values to a non existing pipe key"
  ./yb -af tests/yb.yaml -k "- ascii-test|" -v "|> ___  _ ____ |> \  \///  __\ |>  \  / | | // |>  / /  | |_\\\ |> /_/   \____/"
  parse=$(./yb -qf tests/yb.yaml -k "- ascii-test|" -v "  ___  _ ____  \  \///  __\   \  / | | //   / /  | |_\\\  /_/   \____/")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.13: add pipe type values to an existing pipe key"
  ./yb -af tests/yb.yaml -k "- ascii|" -v "|>  ___  _ |>  \  \// |>   \  / |>   / / |>  /_/"
  parse=$(./yb -qf tests/yb.yaml -k "- ascii|" -v "   ___  _   \  \//    \  /    / /   /_/")
  check_test "true" "${parse}"
	
  echo -e "\U1F4AC PART 4 - Removal "

  echo -e "\U1F4AC Test 4.1: remove non existing key"
  parse=$(./yb -rf tests/yb.yaml -k "non.existing.key")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 4.2: remove existing keys"
  ./yb -rf tests/yb.yaml -k "never"
  ./yb -rf tests/yb.yaml -k "do.exist.not"
  ./yb -rf tests/yb.yaml -k "did not"
  ./yb -rf tests/yb.yaml -k "list"
  ./yb -rf tests/yb.yaml -k "- new.- child"
  ./yb -rf tests/yb.yaml -k "- new"
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 4.3: remove non-existing value"
  ./yb -rf tests/yb.yaml -k "do.exist" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist")
  check_test "true
FALSE" "${parse}"

  echo -e "\U1F4AC Test 4.4: remove existing inline value"
  ./yb -af tests/yb.yaml -k "is.- empty" -v "false"
  ./yb -rf tests/yb.yaml -k "is.- empty" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "is.- empty")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 4.5: remove existing list-value"
  ./yb -af tests/yb.yaml -k "is.- empty" -v "- false"
  ./yb -rf tests/yb.yaml -k "is.- empty" -v "- false"
  parse=$(./yb -Rf tests/yb.yaml -k "is.- empty")
  check_test "" "${parse}"

  # clean key
  ./yb -rf tests/yb.yaml -k "is.- empty"

  echo -e "\U1F4AC Test 4.6: remove nested pipe value"
  ./yb -rf tests/yb.yaml -k "- ascii|" -v "   ___  _   \  \//    \  /    / /   /_/"
  parse=$(./yb -qf tests/yb.yaml -k "- ascii-test|" -v "  ___  _ ____  \  \///  __\   \  / | | //   / /  | |_\\\  /_/   \____/")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.7: remove existing pipe value"
  ./yb -rf tests/yb.yaml -k "- ascii-test|" -v "  ___  _ ____  \  \///  __\   \  / | | //   / /  | |_\\\  /_/   \____/"
  parse=$(./yb -f tests/yb.yaml -k "- ascii-test|")
  check_test "" "${parse}"
  ./yb -rf tests/yb.yaml -k "- ascii-test|"

  # end message
  echo ""
  echo "End of yb tests:"
  echo "Tests passed: ${passed_num}"
  echo "Total tests: ${total_num}"

  # yb Ascii
  ./yb -f tests/yb.yaml -k "- ascii|"
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

main "${@}"