#!/bin/bash
#---------------------------------------
# yb_tests | tests for yb
#---------------------------------------

tests(){
  local yaml_object
  yaml_object=$(./yb -Rf tests/yb.yaml)

	echo -e "\U1F3B2 Welcome to YB tests: "

  # part 1
  echo -e "\U1F4AC PART 1 - Parse"
  test_num=0

	echo -e "\U1F4AC Test 1.${test_num}: parse without options"
	parse=$(./yb)
	check_test "No parameters provided. See the '-h' help option for usage details." "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse without an existing file, file is not a *.yaml or *.yml file"
	parse=$(./yb "not_a_file")
	check_test "A YAML file or object needs to be provided through the '-f' or '-o' options." "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse without an existing file, file is a *.yaml file"
  ./yb -f "tests/new_file.yaml"
  parse=$(if ! [[ -f tests/new_file.yaml ]]; then echo false; fi)
  check_test "false" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key selection without options"
	parse=$(./yb tests/yb.yaml "y")
	check_test "b" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key selection with options"
	parse=$(./yb -f tests/yb.yaml -k "y")
	check_test "b" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key selection with options"
  parse=$(./yb -o "${yaml_object}" -k "y")
  check_test "b" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain"
	parse=$(./yb -f tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain"
  parse=$(./yb -o "${yaml_object}" -k "yb.yaml.bash")
  check_test "- IFS
- BASED
- PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain, targetting an inline key"
	parse=$(./yb -f tests/yb.yaml -k "yaml.yaml.bash.- IFS")
	check_test "BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain, targetting an inline key"
  parse=$(./yb -o "${yaml_object}" -k "yaml.yaml.bash.- IFS")
  check_test "BASED PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain, targetting an inline-key containing a space"
	parse=$(./yb -f tests/yb.yaml -k "complex.strings.- I am")
	check_test "a complex string" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain, targetting an inline-key containing a space"
  parse=$(./yb -o "${yaml_object}" -k "complex.strings.- I am")
  check_test "a complex string" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain and raw option"
	parse=$(./yb -Rf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS
- BASED
- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain and raw option"
  parse=$(./yb -Ro "${yaml_object}" -k "yb.yaml.bash")
  check_test "- IFS
- BASED
- PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with a number output"
	parse=$(./yb -Rf tests/yb.yaml -k "yaml.yaml.yaml.bash.- IFS.- BASED.number")
	check_test "101" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with a number output"
  parse=$(./yb -Ro "${yaml_object}" -k "yaml.yaml.yaml.bash.- IFS.- BASED.number")
  check_test "101" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with a boolean output as an array"
	parse=$(./yb -Af tests/yb.yaml -k "is.a.boolean")
	check_test "true" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with a boolean output as an array"
  parse=$(./yb -Ao "${yaml_object}" -k "is.a.boolean")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with raw option and depth option"
	parse=$(./yb -Rdf tests/yb.yaml -k "yb.yaml.bash")
	check_test "      - IFS
      - BASED
      - PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with raw option and depth option"
  parse=$(./yb -Rdo "${yaml_object}"  -k "yb.yaml.bash")
  check_test "      - IFS
      - BASED
      - PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain and formatting"
	parse=$(./yb -Ff tests/yb.yaml -k "yb.yaml.bash")
	check_test ".bash_- IFS
.bash_- BASED
.bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain and formatting"
  parse=$(./yb -Fo "${yaml_object}" -k "yb.yaml.bash")
  check_test ".bash_- IFS
.bash_- BASED
.bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with formatting and depth"
  parse=$(./yb -Fdf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_- IFS
....bash_- BASED
....bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with formatting and depth"
  parse=$(./yb -Fdo "${yaml_object}" -k "yb.yaml.bash")
  check_test "....bash_- IFS
....bash_- BASED
....bash_- PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain and array option"
  parse=$(./yb -Af tests/yb.yaml -k "yb.yaml.bash")
  check_test "IFS BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain and array option"
  parse=$(./yb -Ao "${yaml_object}" -k "yb.yaml.bash")
  check_test "IFS BASED PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with key chain format and array options"
	parse=$(./yb -FAf tests/yb.yaml -k "yb.yaml.bash")
	check_test ".bash_IFS .bash_BASED .bash_PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with key chain format and array options"
  parse=$(./yb -FAo "${yaml_object}" -k "yb.yaml.bash")
  check_test ".bash_IFS .bash_BASED .bash_PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with formatting, array and depth"
  parse=$(./yb -FAdf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_IFS ....bash_BASED ....bash_PARSER" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with formatting, array and depth"
  parse=$(./yb -FAdo "${yaml_object}" -k "yb.yaml.bash")
  check_test "....bash_IFS ....bash_BASED ....bash_PARSER" "${parse}"

	echo -e "\U1F4AC Test 1.${test_num}: parse file with all -lLn outer options"
	parse=$(./yb -RlLnf tests/yb.yaml -k "yb.yaml.bash")
	check_test "- IFS{{line}}{{3}}{{7}}
- BASED{{line}}{{3}}{{8}}
- PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with all -lLn outer options"
  parse=$(./yb -RlLno "${yaml_object}" -k "yb.yaml.bash")
  check_test "- IFS{{line}}{{3}}{{7}}
- BASED{{line}}{{3}}{{8}}
- PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with all options but depth"
  parse=$(./yb -FARlLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test ".bash_IFS{{line}}{{3}}{{7}} .bash_BASED{{line}}{{3}}{{8}} .bash_PARSER{{line}}{{3}}{{9}}" "${parse}"
       
  echo -e "\U1F4AC Test 1.${test_num}: parse object with all options but depth"
  parse=$(./yb -FARlLno "${yaml_object}" -k "yb.yaml.bash")
  check_test ".bash_IFS{{line}}{{3}}{{7}} .bash_BASED{{line}}{{3}}{{8}} .bash_PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse file with type options"
  parse=$(./yb -RTf tests/yb.yaml -k "yaml.yaml.yaml.bash.- IFS.- BASED")
  check_test "- !! str PARSER
- !! int 1
- !! int 0
- !! int 1
number: !! int 101
float-number: !! float 101.01" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with type options"
  parse=$(./yb -RTo "${yaml_object}" -k "yaml.yaml.yaml.bash.- IFS.- BASED")
  check_test "- !! str PARSER
- !! int 1
- !! int 0
- !! int 1
number: !! int 101
float-number: !! float 101.01" "${parse}"
  
  echo -e "\U1F4AC Test 1.${test_num}: parse file with all compatible options"
  parse=$(./yb -FARTldLnf tests/yb.yaml -k "yb.yaml.bash")
  check_test "....bash_!! str IFS{{line}}{{3}}{{7}} ....bash_!! str BASED{{line}}{{3}}{{8}} ....bash_!! str PARSER{{line}}{{3}}{{9}}" "${parse}"

  echo -e "\U1F4AC Test 1.${test_num}: parse object with all compatible options"
  parse=$(./yb -FARTldLno "${yaml_object}" -k "yb.yaml.bash")
  check_test "....bash_!! str IFS{{line}}{{3}}{{7}} ....bash_!! str BASED{{line}}{{3}}{{8}} ....bash_!! str PARSER{{line}}{{3}}{{9}}" "${parse}"

  # 
  # part 2
  # 
  echo -e "\U1F4AC PART 2 - Query"
  test_num=0

  echo -e "\U1F4AC Test 2.${test_num}: query file for a non-existing key"
  parse=$(./yb -qf tests/yb.yaml -k "do.exist.not")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for a non-existing key"
  parse=$(./yb -qo "${yaml_object}" -k "do.exist.not")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for an existing key"
  parse=$(./yb -qf tests/yb.yaml -k "do.exist")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for an existing key"
  parse=$(./yb -qo "${yaml_object}" -k "do.exist")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for a non-existing value"
  parse=$(./yb -qf tests/yb.yaml -k "do.exist" -v "Does exist")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for a non-existing value"
  parse=$(./yb -qo "${yaml_object}" -k "do.exist" -v "Does exist")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for single existing value"
  parse=$(./yb -qf tests/yb.yaml -k "not.to.be.- found" -v "TRUE")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for single existing value"
  parse=$(./yb -qo "${yaml_object}" -k "not.to.be.- found" -v "TRUE")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for multiple existing values"
  parse=$(./yb -qf tests/yb.yaml -k "do" -v "true")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for multiple existing values"
  parse=$(./yb -qo "${yaml_object}" -k "do" -v "true")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for existing inline value"
  parse=$(./yb -qf tests/yb.yaml -k "yaml.yaml.bash.- IFS" -v "BASED PARSER")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for existing inline value"
  parse=$(./yb -qo "${yaml_object}" -k "yaml.yaml.bash.- IFS" -v "BASED PARSER")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query file for existing pipe values"
  parse=$(./yb -qf tests/yb.yaml -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 2.${test_num}: query object for existing pipe values"
  parse=$(./yb -qo "${yaml_object}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  # 
  # part 3
  # 
  echo -e "\U1F4AC PART 3 - Add"
  test_num=0

  echo -e "\U1F4AC Test 3.${test_num}: add existing key to file"
  # should be improved to retrieve error code
  parse=$(./yb -af tests/yb.yaml -k "do.exist")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add existing key to object"
  # should be improved to retrieve error code
  parse=$(./yb -ao "${yaml_object}" -k "do.exist")
  check_test "${yaml_object}" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non-existing key to file"
  ./yb -af tests/yb.yaml -k "never.existed.before"
  parse=$(./yb -qf tests/yb.yaml -k "never.existed.before")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non-existing key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "never.existed.before")
  parse=$(./yb -qo "${yaml_object}" -k "never.existed.before")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num} add partially-existing key to file"
  ./yb -af tests/yb.yaml -k "do.exist.not"
  parse=$(./yb -qf tests/yb.yaml -k "do.exist.not")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num} add partially-existing key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "do.exist.not")
  parse=$(./yb -qo "${yaml_object}" -k "do.exist.not")
  check_test "true
true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non existing list-key to file"
  ./yb -af tests/yb.yaml -k "- new"
  parse=$(./yb -qf tests/yb.yaml -k "- new")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add non existing list-key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "- new")
  parse=$(./yb -qo "${yaml_object}" -k "- new")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add partially-existing list-key to file"
  ./yb -af tests/yb.yaml -k "- new.- child"
  parse=$(./yb -qf tests/yb.yaml -k "- new.- child")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add partially-existing list-key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "- new.- child")
  parse=$(./yb -qo "${yaml_object}" -k "- new.- child")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to an empty existing key to file"
  ./yb -af tests/yb.yaml -k "do.exist.not" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist.not")
  check_test "false
false" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to an empty existing key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "do.exist.not" -v "false")
  parse=$(./yb -Ro "${yaml_object}" -k "do.exist.not")
  check_test "false
false" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-empty existing key to file"
  ./yb -af tests/yb.yaml -k "do.exist.not" -v "true"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist.not")
  check_test "false true
false true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-empty existing key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "do.exist.not" -v "true")
  parse=$(./yb -Ro "${yaml_object}" -k "do.exist.not")
  check_test "false true
false true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-existing key with a space to file"
  ./yb -af tests/yb.yaml -k "did not.exist.before" -v "true"
  parse=$(./yb -Rf tests/yb.yaml -k "did not.exist.before")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add inline value to a non-existing key with a space to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "did not.exist.before" -v "true")
  parse=$(./yb -Ro "${yaml_object}" -k "did not.exist.before")
  check_test "true" "${parse}"
  
  echo -e "\U1F4AC Test 3.${test_num}: add list value to a non-existing key to file"
  ./yb -af tests/yb.yaml -k "list.which.do.exist" -v "- true"
  parse=$(./yb -Rf tests/yb.yaml -k "list.which.do.exist")
  check_test "- true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add list value to a non-existing key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "list.which.do.exist" -v "- true")
  parse=$(./yb -Ro "${yaml_object}" -k "list.which.do.exist")
  check_test "- true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add multiple list values to an existing key to file"
  ./yb -af tests/yb.yaml -k "list.which.do.exist" -v "- yes - right"
  parse=$(./yb -Rf tests/yb.yaml -k "list.which.do.exist")
  check_test "- yes
- right
- true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add multiple list values to an existing key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "list.which.do.exist" -v "- yes - right")
  parse=$(./yb -Ro "${yaml_object}" -k "list.which.do.exist")
  check_test "- yes
- right
- true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add complex inline value to a non existing key to file"
  ./yb -af tests/yb.yaml -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.'
  parse=$(./yb -qf tests/yb.yaml -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add complex inline value to a non existing key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.')
  parse=$(./yb -qo "${yaml_object}" -k "list.which.do.exist.- key" -v '\"Complex string\" \\t\\t\\t\\t tabs, newlines\\n\\n, and \${special} \${very special} character.')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to a non existing pipe key to file"
  ./yb -af tests/yb.yaml -k "- ascii-test|" -v "|> ___  _ ____ |> \  \///  __\ |>  \  / | | // |>  / /  | |_\\\ |> /_/   \____/"
  parse=$(./yb -qf tests/yb.yaml -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to a non existing pipe key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "- ascii-test|" -v "|> ___  _ ____ |> \  \///  __\ |>  \  / | | // |>  / /  | |_\\\ |> /_/   \____/")
  parse=$(./yb -qo "${yaml_object}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to an existing pipe key to file"
  ./yb -af tests/yb.yaml -k "- ascii|" -v "|>  ___  _ |>  \  \// |>   \  / |>   / / |>  /_/"
  parse=$(./yb -qf tests/yb.yaml -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 3.${test_num}: add pipe type values to an existing pipe key to object"
  yaml_object=$(./yb -ao "${yaml_object}" -k "- ascii|" -v "|>  ___  _ |>  \  \// |>   \  / |>   / / |>  /_/")
  parse=$(./yb -qo "${yaml_object}" -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/')
  check_test "true" "${parse}"

  # 
  # part 4
  # 
  echo -e "\U1F4AC PART 4 - Change"
  test_num=0

  echo -e "\U1F4AC Test 4.${test_num}: change non existing key in file"
  ./yb -cf tests/yb.yaml -k "was.not.changed" -v "true"
  parse=$(./yb -qf tests/yb.yaml -k "was.not.changed")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change non existing key in object"
  yaml_object=$(./yb -co "${yaml_object}" -k "was.not.changed" -v "true")
  parse=$(./yb -qo "${yaml_object}" -k "was.not.changed")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change partially existing key in file"
  ./yb -cf tests/yb.yaml -k "was.not.- previously" -v "true"
  parse=$(./yb -qf tests/yb.yaml -k "was.not.- previously")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change partially existing key in object"
  yaml_object=$(./yb -co "${yaml_object}" -k "was.not.- previously" -v "true")
  parse=$(./yb -qo "${yaml_object}" -k "was.not.- previously")
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, without value in file"
  parse=$(./yb -cf tests/yb.yaml -k "was.not.- previously")
  check_test "Values are needed when using the -c option." "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, without value in object"
  parse=$(./yb -co "${yaml_object}" -k "was.not.- previously")
  check_test "Values are needed when using the -c option." "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, with value in file"
  ./yb -cf tests/yb.yaml -k "was.not.- previously" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "was.not.- previously")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing key, with value in object"
  yaml_object=$(./yb -co "${yaml_object}" -k "was.not.- previously" -v "false")
  parse=$(./yb -Ro "${yaml_object}" -k "was.not.- previously")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing pipe-value in file"
  ./yb -cf tests/yb.yaml -k "- ascii-test|" -v '|>  ____ |> /  __\ |> | | // |> | |_\\ |> \____/'
  parse=$(./yb -qf tests/yb.yaml -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 4.${test_num}: change existing pipe-value in object"
  yaml_object=$(./yb -co "${yaml_object}" -k "- ascii-test|" -v '|>  ____ |> /  __\ |> | | // |> | |_\\ |> \____/')
  parse=$(./yb -qo "${yaml_object}" -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/')
  check_test "true" "${parse}"
	

  # 
  # part 5
  # 
  echo -e "\U1F4AC PART 5 - Remove"
  test_num=0

  echo -e "\U1F4AC Test 5.${test_num}: remove non existing key"
  ./yb -rf tests/yb.yaml -k "non.existing.key"
  parse=$(./yb -qf tests/yb.yaml -k "non.existing.key")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove non existing key"
  yaml_object=$(./yb -ro "${yaml_object}" -k "non.existing.key")
  parse=$(./yb -qo "${yaml_object}" -k "non.existing.key")
  check_test "false" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing keys"
  ./yb -rf tests/yb.yaml -k "never"
  ./yb -rf tests/yb.yaml -k "do.exist.not"
  ./yb -rf tests/yb.yaml -k "did not"
  ./yb -rf tests/yb.yaml -k "list"
  ./yb -rf tests/yb.yaml -k "- new.- child"
  ./yb -rf tests/yb.yaml -k "- new"
  ./yb -rf tests/yb.yaml -k "was"
  parse=""
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing keys"
  yaml_object=$(./yb -ro "${yaml_object}" -k "never")
  yaml_object=$(./yb -ro "${yaml_object}" -k "do.exist.not")
  yaml_object=$(./yb -ro "${yaml_object}" -k "did not")
  yaml_object=$(./yb -ro "${yaml_object}" -k "list")
  yaml_object=$(./yb -ro "${yaml_object}" -k "- new.- child")
  yaml_object=$(./yb -ro "${yaml_object}" -k "- new")
  yaml_object=$(./yb -ro "${yaml_object}" -k "was")
  parse=""
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove non-existing value"
  ./yb -rf tests/yb.yaml -k "do.exist" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "do.exist")
  check_test "true
FALSE" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove non-existing value"
  yaml_object=$(./yb -ro "${yaml_object}" -k "do.exist" -v "false")
  parse=$(./yb -Ro "${yaml_object}" -k "do.exist")
  check_test "true
FALSE" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing inline value"
  ./yb -af tests/yb.yaml -k "is.- empty" -v "false"
  ./yb -rf tests/yb.yaml -k "is.- empty" -v "false"
  parse=$(./yb -Rf tests/yb.yaml -k "is.- empty")
  check_test "" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing inline value"
  yaml_object=$(./yb -ao "${yaml_object}" -k "is.- empty" -v "false")
  yaml_object=$(./yb -ro "${yaml_object}" -k "is.- empty" -v "false")
  parse=$(./yb -Ro "${yaml_object}" -k "is.- empty")
  check_test "" "${parse}"


  echo -e "\U1F4AC Test 5.${test_num}: remove existing list-value"
  ./yb -af tests/yb.yaml -k "is.- empty" -v "- false"
  ./yb -rf tests/yb.yaml -k "is.- empty" -v "- false"
  parse=$(./yb -Rf tests/yb.yaml -k "is.- empty")
  check_test "" "${parse}"
  
  echo -e "\U1F4AC Test 5.${test_num}: remove existing list-value"
  yaml_object=$(./yb -ao "${yaml_object}" -k "is.- empty" -v "- false")
  yaml_object=$(./yb -ro "${yaml_object}" -k "is.- empty" -v "- false")
  parse=$(./yb -Ro "${yaml_object}" -k "is.- empty")
  check_test "" "${parse}"

  # clean key
  # from file
  ./yb -rf tests/yb.yaml -k "is.- empty"

  # from object
  yaml_object=$(./yb -ro "${yaml_object}" -k "is.- empty")
  
  echo -e "\U1F4AC Test 5.${test_num}: remove nested pipe value"
  ./yb -rf tests/yb.yaml -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/'
  parse=$(./yb -qf tests/yb.yaml -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"
  
  echo -e "\U1F4AC Test 5.${test_num}: remove nested pipe value"
  yaml_object=$(./yb -ro "${yaml_object}" -k "- ascii|" -v ' ___  _ \  \//  \  /  / / /_/')
  parse=$(./yb -qo "${yaml_object}" -k "- ascii|" -v '___  _ ____\  \///  __\ \  / | | // / /  | |_\\/_/   \____/')
  check_test "true" "${parse}"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing pipe value"
  ./yb -rf tests/yb.yaml -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/'
  parse=$(./yb -f tests/yb.yaml -k "- ascii-test|")
  check_test "" "${parse}"
  ./yb -rf tests/yb.yaml -k "- ascii-test|"

  echo -e "\U1F4AC Test 5.${test_num}: remove existing pipe value"
  yaml_object=$(./yb -ro "${yaml_object}" -k "- ascii-test|" -v ' ____/  __\| | //| |_\\\____/')
  parse=$(./yb -o "${yaml_object}" -k "- ascii-test|")
  check_test "" "${parse}"
  yaml_object=$(./yb -ro "${yaml_object}" -k "- ascii-test|")

  # end message
  echo ""
  echo "End of yb tests:"
  echo "Tests passed: ${passed_num}"
  echo "Total tests: ${total_num}"

  # yb Ascii
  ./yb -o "${yaml_object}" -k "- ascii|"
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
	((test_num++))
  ((total_num++))
}

globals(){
	declare -g test_num=0
  declare -g total_num=0
	declare -g passed_num=0
	declare -g error_code
}

main(){
	globals
	time tests
}

main "${@}"