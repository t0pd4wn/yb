#!/bin/bash
#---------------------------------------
# yb_tests | tests for yb
#---------------------------------------

tests(){
  local program="${1:-yb}"
  local yaml_file="tests/yb.yaml"
  local yaml_object
  yaml_object=$("./${program}" -Rf "${yaml_file}")
  local value

	echo -e "\U1F3B2 Welcome to YB tests: "

  # part 1
  echo -e "\U1F4AC PART 1 - Parse"
  test_num=0

	echo -e "\U1F4AC Test 1.${test_num}: parse without options"
  echo "${program}"
	parse=$("./${program}")
	check_test "No parameters provided. See the '-h' help option for usage details." "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse without an existing file, file is not a *.yaml or *.yml file"
	parse=$("./${program}" "not_a_file")
	check_test "A YAML file or object needs to be provided through the '-f' or '-o' options." "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse without an existing file, file is a *.yaml file"
  "./${program}" -f "tests/new_file.yaml"
  parse=$(if ! [[ -f tests/new_file.yaml ]]; then echo false; fi)
  check_test "false" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key selection without options"
	parse=$("./${program}" "${yaml_file}" "y")
	check_test "b" "${parse}"

  parse=$("./${program}" -f "${yaml_file}" -o "y")
  echo -e "\U1F4AC Test 1.${test_num}: parse file both -f and -o options."
  check_test "-f file and -o object can not be used together. Use -O to add object value type to YAML file or object." "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key selection with options"
	parse=$("./${program}" -f "${yaml_file}" -k "y")
	check_test "b" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key selection with options"
  parse=$("./${program}" -o "${yaml_object}" -k "y")
  check_test "b" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain"
	parse=$("./${program}" -f "${yaml_file}" -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain"
  parse=$("./${program}" -o "${yaml_object}" -k "yb.yaml.bash")
  check_test "- IFS
- BASED
- PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain, targetting an inline key"
	parse=$("./${program}" -Rf "${yaml_file}" -k "yaml.yaml.bash.- IFS")
	check_test "BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain, targetting an inline key"
  parse=$("./${program}" -Ro "${yaml_object}" -k "yaml.yaml.bash.- IFS")
  check_test "BASED PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain, targetting an inline-key containing a space"
	parse=$("./${program}" -Rf "${yaml_file}" -k "complex.strings.- I am")
  check_test "a complex string" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain, targetting an inline-key containing a space"
  parse=$("./${program}" -o "${yaml_object}" -k "complex.strings.- I am")
  check_test "a complex string" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain, targetting a string with inline comment"
  parse=$("./${program}" -f "${yaml_file}" -k "yaml.yaml.bash.- IFS")
  check_test $'BASED PARSER\E[30m # inline comment\E[0m' "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain, targetting a string with inline comment"
  parse=$("./${program}" -o "${yaml_object}" -k "yaml.yaml.bash.- IFS")
  check_test $'BASED PARSER' "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain, targetting a set of complex strings"
  parse=$("./${program}" -Rf "${yaml_file}" -k "complex.strings")
  value="- trick::
- \\033[0;30m
- I am: a complex string
- key: or string
- string: \"this string: \"
- \"String says: I am a string !\"
- 'this string: '
- inline-string: \"this string: \"
- this string#
- 'this string #'
- \"this string #\"
- \n
- \\\"Complex string\\\" \t\t\t\t tabs, newlines\n\n, and \\\${special} \\\${very special} characters.
- Complex-string- and::very special::characters."
  check_test "${value}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain, targetting a set of complex strings"
  parse=$("./${program}" -Ro "${yaml_object}" -k "complex.strings")
  value="- trick::
- \\033[0;30m
- I am: a complex string
- key: or string
- string: \"this string: \"
- \"String says: I am a string !\"
- 'this string: '
- inline-string: \"this string: \"
- this string#
- 'this string #'
- \"this string #\"
- \n
- \\\"Complex string\\\" \t\t\t\t tabs, newlines\n\n, and \\\${special} \\\${very special} characters.
- Complex-string- and::very special::characters."
  check_test "${value}" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain and raw option"
	parse=$("./${program}" -Rf "${yaml_file}" -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain and raw option"
  parse=$("./${program}" -Ro "${yaml_object}" -k "yb.yaml.bash")
  check_test "- IFS
- BASED
- PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with a number output"
	parse=$("./${program}" -Rf "${yaml_file}" -k "yaml.yaml.yaml.bash.- IFS.- BASED.number")
	check_test "101" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with a number output"
  parse=$("./${program}" -Ro "${yaml_object}" -k "yaml.yaml.yaml.bash.- IFS.- BASED.number")
  check_test "101" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with a boolean output as an array"
	parse=$("./${program}" -Af "${yaml_file}" -k "is.a.boolean")
	check_test "true" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with a boolean output as an array"
  parse=$("./${program}" -Ao "${yaml_object}" -k "is.a.boolean")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with raw option and depth option"
	parse=$("./${program}" -Rdf "${yaml_file}" -k "yb.yaml.bash")
	check_test "      - IFS
      - BASED
      - PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with raw option and depth option"
  parse=$("./${program}" -Rdo "${yaml_object}"  -k "yb.yaml.bash")
  check_test "      - IFS
      - BASED
      - PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain and formatting"
	parse=$("./${program}" -Ff "${yaml_file}" -k "yb.yaml.bash")
	check_test ".bash_- IFS
.bash_- BASED
.bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain and formatting"
  parse=$("./${program}" -Fo "${yaml_object}" -k "yb.yaml.bash")
  check_test ".bash_- IFS
.bash_- BASED
.bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with formatting and depth"
  parse=$("./${program}" -Fdf "${yaml_file}" -k "yb.yaml.bash")
  check_test "....bash_- IFS
....bash_- BASED
....bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with formatting and depth"
  parse=$("./${program}" -Fdo "${yaml_object}" -k "yb.yaml.bash")
  check_test "....bash_- IFS
....bash_- BASED
....bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain and array option"
  parse=$("./${program}" -Af "${yaml_file}" -k "yb.yaml.bash")
  check_test "IFS BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain and array option"
  parse=$("./${program}" -Ao "${yaml_object}" -k "yb.yaml.bash")
  check_test "IFS BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain format and array options"
	parse=$("./${program}" -FAf "${yaml_file}" -k "yb.yaml.bash")
	check_test ".bash_IFS .bash_BASED .bash_PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain format and array options"
  parse=$("./${program}" -FAo "${yaml_object}" -k "yb.yaml.bash")
  check_test ".bash_IFS .bash_BASED .bash_PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with formatting, array and depth"
  parse=$("./${program}" -FAdf "${yaml_file}" -k "yb.yaml.bash")
  check_test "....bash_IFS ....bash_BASED ....bash_PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with formatting, array and depth"
  parse=$("./${program}" -FAdo "${yaml_object}" -k "yb.yaml.bash")
  check_test "....bash_IFS ....bash_BASED ....bash_PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with all -lLn outer options"
	parse=$("./${program}" -RlLnf "${yaml_file}" -k "yb.yaml.bash")
	check_test "- IFS{{line}}{{3}}{{7}}
- BASED{{line}}{{3}}{{8}}
- PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with all -lLn outer options"
  parse=$("./${program}" -RlLno "${yaml_object}" -k "yb.yaml.bash")
  # note: line numbers are different in the object scenario 
  # because the YAML was parsed using the -R option
  check_test "- IFS{{line}}{{3}}{{5}}
- BASED{{line}}{{3}}{{6}}
- PARSER{{line}}{{3}}{{7}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with all options but depth"
  parse=$("./${program}" -FARlLnf "${yaml_file}" -k "yb.yaml.bash")
  check_test ".bash_IFS{{line}}{{3}}{{7}} .bash_BASED{{line}}{{3}}{{8}} .bash_PARSER{{line}}{{3}}{{9}}" "${parse}"
       
  echo -e "\U1F4AC Test 1.${test_num}: parse object with all options but depth"
  parse=$("./${program}" -FARlLno "${yaml_object}" -k "yb.yaml.bash")
  # note: line numbers are different in the object scenario 
  # because the YAML was parsed using the -R option
  check_test ".bash_IFS{{line}}{{3}}{{5}} .bash_BASED{{line}}{{3}}{{6}} .bash_PARSER{{line}}{{3}}{{7}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with type options"
  parse=$("./${program}" -RTf "${yaml_file}" -k "yaml.yaml.yaml.bash.- IFS.- BASED")
  check_test "- !! str PARSER
- !! int 1
- !! int 0
- !! int 1
number: !! int 101
float-number: !! float 101.01" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with type options"
  parse=$("./${program}" -RTo "${yaml_object}" -k "yaml.yaml.yaml.bash.- IFS.- BASED")
  check_test "- !! str PARSER
- !! int 1
- !! int 0
- !! int 1
number: !! int 101
float-number: !! float 101.01" "${parse}"
  
  echo -e "\U1F4AC Test 1.${test_num}: parse file with all compatible options"
  parse=$("./${program}" -FARTldLnf "${yaml_file}" -k "yb.yaml.bash")
  check_test "....bash_!! str IFS{{line}}{{3}}{{7}} ....bash_!! str BASED{{line}}{{3}}{{8}} ....bash_!! str PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with all compatible options"
  parse=$("./${program}" -FARTldLno "${yaml_object}" -k "yb.yaml.bash")
  # note: line numbers are different in the object scenario 
  # because the YAML was parsed using the -R option
  check_test "....bash_!! str IFS{{line}}{{3}}{{5}} ....bash_!! str BASED{{line}}{{3}}{{6}} ....bash_!! str PARSER{{line}}{{3}}{{7}}" "${parse}"

  # 
  # part 2
  # 
  echo -e "\U1F4AC PART 2 - Query"
  test_num=0

  echo -e "\U1F4AC Test 2.${test_num}: query file for a non-existing key"
  parse=$("./${program}" -qf "${yaml_file}" -k "do.exist.not")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for a non-existing key"
  parse=$("./${program}" -qo "${yaml_object}" -k "do.exist.not")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for an existing key"
  parse=$("./${program}" -qf "${yaml_file}" -k "do.exist")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for an existing key"
  parse=$("./${program}" -qo "${yaml_object}" -k "do.exist")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for a non-existing value"
  parse=$("./${program}" -qf "${yaml_file}" -k "do.exist" -v "Does exist")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for a non-existing value"
  parse=$("./${program}" -qo "${yaml_object}" -k "do.exist" -v "Does exist")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for single existing value"
  parse=$("./${program}" -qf "${yaml_file}" -k "not.to.be.- found" -v "TRUE")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for single existing value"
  parse=$("./${program}" -qo "${yaml_object}" -k "not.to.be.- found" -v "TRUE")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for multiple existing values"
  parse=$("./${program}" -qf "${yaml_file}" -k "do" -v "true")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for multiple existing values"
  parse=$("./${program}" -qo "${yaml_object}" -k "do" -v "true")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for existing inline value"
  parse=$("./${program}" -qf "${yaml_file}" -k "yaml.yaml.bash.- IFS" -v "BASED PARSER")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for existing inline value"
  parse=$("./${program}" -qo "${yaml_object}" -k "yaml.yaml.bash.- IFS" -v "BASED PARSER")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for existing pipe values"
  parse=$("./${program}" -qf "${yaml_file}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for existing pipe values"
  parse=$("./${program}" -qo "${yaml_object}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  # 
  # part 3
  # 
  echo -e "\U1F4AC PART 3 - Add"
  test_num=0

  echo -e "\U1F4AC Test 3.${test_num}: add existing key to file"
  # should be improved to retrieve error code
  parse=$("./${program}" -af "${yaml_file}" -k "do.exist")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add existing key to object"
  # should be improved to retrieve error code
  parse=$("./${program}" -ao "${yaml_object}" -k "do.exist")
  check_test "${yaml_object}" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non-existing key to file"
  "./${program}" -af "${yaml_file}" -k "never.existed.before"
  parse=$("./${program}" -qf "${yaml_file}" -k "never.existed.before")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non-existing key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "never.existed.before")
  parse=$("./${program}" -qo "${yaml_object}" -k "never.existed.before")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num} add partially-existing key to file"
  "./${program}" -af "${yaml_file}" -k "do.exist.not"
  parse=$("./${program}" -qf "${yaml_file}" -k "do.exist.not")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num} add partially-existing key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "do.exist.not")
  parse=$("./${program}" -qo "${yaml_object}" -k "do.exist.not")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non existing list-key to file"
  "./${program}" -af "${yaml_file}" -k "- new"
  parse=$("./${program}" -qf "${yaml_file}" -k "- new")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non existing list-key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "- new")
  parse=$("./${program}" -qo "${yaml_object}" -k "- new")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add partially-existing list-key to file"
  "./${program}" -af "${yaml_file}" -k "- new.- child"
  parse=$("./${program}" -qf "${yaml_file}" -k "- new.- child")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add partially-existing list-key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "- new.- child")
  parse=$("./${program}" -qo "${yaml_object}" -k "- new.- child")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to an empty existing key to file"
  "./${program}" -af "${yaml_file}" -k "do.exist.not" -v "false"
  parse=$("./${program}" -Rf "${yaml_file}" -k "do.exist.not")
  check_test "false
false" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to an empty existing key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "do.exist.not" -v "false")
  parse=$("./${program}" -Ro "${yaml_object}" -k "do.exist.not")
  check_test "false
false" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-empty existing key to file"
  "./${program}" -af "${yaml_file}" -k "do.exist.not" -v "true"
  parse=$("./${program}" -Rf "${yaml_file}" -k "do.exist.not")
  check_test "false true
false true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-empty existing key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "do.exist.not" -v "true")
  parse=$("./${program}" -Ro "${yaml_object}" -k "do.exist.not")
  check_test "false true
false true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-existing key with a space to file"
  "./${program}" -af "${yaml_file}" -k "did not.exist.before" -v "true"
  parse=$("./${program}" -Rf "${yaml_file}" -k "did not.exist.before")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-existing key with a space to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "did not.exist.before" -v "true")
  parse=$("./${program}" -Ro "${yaml_object}" -k "did not.exist.before")
  check_test "true" "${parse}"
  
  echo -e "\U1F4AC Test 3.${test_num}: add list value to a non-existing key to file"
  "./${program}" -af "${yaml_file}" -k "list.which.do.exist" -v "- true"
  parse=$("./${program}" -Rf "${yaml_file}" -k "list.which.do.exist")
  check_test "- true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add list value to a non-existing key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "list.which.do.exist" -v "- true")
  parse=$("./${program}" -Ro "${yaml_object}" -k "list.which.do.exist")
  check_test "- true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add multiple list values to an existing key to file"
  "./${program}" -af "${yaml_file}" -k "list.which.do.exist" -v "- yes - right"
  parse=$("./${program}" -Rf "${yaml_file}" -k "list.which.do.exist")
  check_test "- true
- yes
- right" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add multiple list values to an existing key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "list.which.do.exist" -v "- yes - right")
  parse=$("./${program}" -Ro "${yaml_object}" -k "list.which.do.exist")
  check_test "- true
- yes
- right" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add complex inline value to a non existing key to file"
  "./${program}" -af "${yaml_file}" -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.'
  parse=$("./${program}" -qf "${yaml_file}" -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add complex inline value to a non existing key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.')
  parse=$("./${program}" -qo "${yaml_object}" -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to a non existing pipe key to file"
  "./${program}" -af "${yaml_file}" -k "- ascii-test|" -v "|> ___  _ ____ |> \  \///  __\ |>  \  / | | // |>  / /  | |_\\\ |> /_/   \____/"
  parse=$("./${program}" -qf "${yaml_file}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to a non existing pipe key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "- ascii-test|" -v "|> ___  _ ____ |> \  \///  __\ |>  \  / | | // |>  / /  | |_\\\ |> /_/   \____/")
  parse=$("./${program}" -qo "${yaml_object}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to an existing pipe key to file"
  "./${program}" -af "${yaml_file}" -k "- ascii|" -v "|>  ___  _ |>  \  \// |>   \  / |>   / / |>  /_/"
  parse=$("./${program}" -qf "${yaml_file}" -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to an existing pipe key to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "- ascii|" -v "|>  ___  _ |>  \  \// |>   \  / |>   / / |>  /_/")
  parse=$("./${program}" -qo "${yaml_object}" -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add object to file"
  ./"${program}" -af "${yaml_file}" -k "do.exist" -O "- object: value"
  parse=$("./${program}" -qf "${yaml_file}" -k "do.exist.- object")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add object to object"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "do.exist" -O "- object: value")
  parse=$("./${program}" -qo "${yaml_object}" -k "do.exist.- object")
  check_test "true
true" "${parse}"

  # 
  # part 4
  # 
  echo -e "\U1F4AC PART 4 - Change"
  test_num=0

  echo -e "\U1F4AC Test 4.${test_num}: change non existing key in file"
  "./${program}" -cf "${yaml_file}" -k "was.not.changed" -v "true"
  parse=$("./${program}" -qf "${yaml_file}" -k "was.not.changed")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change non existing key in object"
  yaml_object=$("./${program}" -co "${yaml_object}" -k "was.not.changed" -v "true")
  parse=$("./${program}" -qo "${yaml_object}" -k "was.not.changed")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change partially existing key in file"
  "./${program}" -cf "${yaml_file}" -k "was.not.- previously" -v "true"
  parse=$("./${program}" -qf "${yaml_file}" -k "was.not.- previously")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change partially existing key in object"
  yaml_object=$("./${program}" -co "${yaml_object}" -k "was.not.- previously" -v "true")
  parse=$("./${program}" -qo "${yaml_object}" -k "was.not.- previously")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, without value in file"
  parse=$("./${program}" -cf "${yaml_file}" -k "was.not.- previously")
  check_test "Values are needed when using the '-c' option." "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, without value in object"
  parse=$("./${program}" -co "${yaml_object}" -k "was.not.- previously")
  check_test "Values are needed when using the '-c' option." "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, with value in file"
  "./${program}" -cf "${yaml_file}" -k "was.not.- previously" -v "false"
  parse=$("./${program}" -Rf "${yaml_file}" -k "was.not.- previously")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, with value in object"
  yaml_object=$("./${program}" -co "${yaml_object}" -k "was.not.- previously" -v "false")
  parse=$("./${program}" -Ro "${yaml_object}" -k "was.not.- previously")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing pipe-value in file"
  "./${program}" -cf "${yaml_file}" -k "- ascii-test|" -v '|>  ____ |> /  __\ |> | | // |> | |_\\ |> \____/'
  parse=$("./${program}" -qf "${yaml_file}" -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing pipe-value in object"
  yaml_object=$("./${program}" -co "${yaml_object}" -k "- ascii-test|" -v '|>  ____ |> /  __\ |> | | // |> | |_\\ |> \____/')
  parse=$("./${program}" -qo "${yaml_object}" -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/')
  check_test "true" "${parse}"
	
  # 
  # part 5
  # 
  echo -e "\U1F4AC PART 5 - Remove"
  test_num=0

  echo -e "\U1F4AC Test 5.${test_num}: remove non existing key"
  "./${program}" -rf "${yaml_file}" -k "non.existing.key"
  parse=$("./${program}" -qf "${yaml_file}" -k "non.existing.key")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove non existing key"
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "non.existing.key")
  parse=$("./${program}" -qo "${yaml_object}" -k "non.existing.key")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing keys"
  "./${program}" -rf "${yaml_file}" -k "never"
  "./${program}" -rf "${yaml_file}" -k "do.exist.not"
  "./${program}" -rf "${yaml_file}" -k "do.exist.- object"
  "./${program}" -rf "${yaml_file}" -k "did not"
  "./${program}" -rf "${yaml_file}" -k "list"
  "./${program}" -rf "${yaml_file}" -k "- new.- child"
  "./${program}" -rf "${yaml_file}" -k "- new"
  "./${program}" -rf "${yaml_file}" -k "was"
  parse=""
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing keys"
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "never")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "do.exist.not")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "did not")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "list")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "- new.- child")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "- new")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "was")
  parse=""
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove non-existing value"
  "./${program}" -rf "${yaml_file}" -k "do.exist" -v "false"
  parse=$("./${program}" -Rf "${yaml_file}" -k "do.exist")
  check_test "true
FALSE" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove non-existing value"
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "do.exist" -v "false")
  parse=$("./${program}" -Ro "${yaml_object}" -k "do.exist")
  check_test "true
FALSE" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing inline value"
  "./${program}" -af "${yaml_file}" -k "is.- empty" -v "false"
  "./${program}" -rf "${yaml_file}" -k "is.- empty" -v "false"
  parse=$("./${program}" -Rf "${yaml_file}" -k "is.- empty")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing inline value"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "is.- empty" -v "false")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "is.- empty" -v "false")
  parse=$("./${program}" -Ro "${yaml_object}" -k "is.- empty")
  check_test "" "${parse}"


  echo -e "\U1F4AC Test 5.${test_num}: remove existing list-value"
  "./${program}" -af "${yaml_file}" -k "is.- empty" -v "- false"
  "./${program}" -rf "${yaml_file}" -k "is.- empty" -v "- false"
  parse=$("./${program}" -Rf "${yaml_file}" -k "is.- empty")
  check_test "" "${parse}"
  
  echo -e "\U1F4AC Test 5.${test_num}: remove existing list-value"
  yaml_object=$("./${program}" -ao "${yaml_object}" -k "is.- empty" -v "- false")
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "is.- empty" -v "- false")
  parse=$("./${program}" -Ro "${yaml_object}" -k "is.- empty")
  check_test "" "${parse}"

  # clean key
  # from file
  "./${program}" -rf "${yaml_file}" -k "is.- empty"

  # from object
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "is.- empty")
  
  echo -e "\U1F4AC Test 5.${test_num}: remove nested pipe value"
  "./${program}" -rf "${yaml_file}" -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/'
  parse=$("./${program}" -qf "${yaml_file}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"
  
  echo -e "\U1F4AC Test 5.${test_num}: remove nested pipe value"
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/')
  parse=$("./${program}" -qo "${yaml_object}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing pipe value"
  "./${program}" -rf "${yaml_file}" -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/'
  parse=$("./${program}" -f "${yaml_file}" -k "- ascii-test|")
  check_test "" "${parse}"
  "./${program}" -rf "${yaml_file}" -k "- ascii-test|"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing pipe value"
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/')
  parse=$("./${program}" -o "${yaml_object}" -k "- ascii-test|")
  check_test "" "${parse}"
  yaml_object=$("./${program}" -ro "${yaml_object}" -k "- ascii-test|")

  # end message
  echo ""
  echo "End of yb tests:"
  echo "Tests passed: ${passed_num}"
  echo "Total tests: ${total_num}"

  # yb Ascii
  "./${program}" -f "${yaml_file}" -k "- ascii|"
}

check_test(){
	local assertion="${1-}"
	local result="${2-}"

	if [[ "${result}" == "${assertion}" ]]; then
		echo -e "\033[1;36mPassed\033[0m"
		((passed_num++))
	else
		echo -e "\033[1;33mFailed\033[0m"
		error_code=1
	fi
	((test_num++))
  ((total_num++))
}

globals(){
	declare -g test_num=0
  declare -g total_num=0
	declare -g passed_num=0
	declare -g error_code=0
}

main(){
	globals
	time tests "${@}"
  exit "${error_code}"
}

main "${@}"