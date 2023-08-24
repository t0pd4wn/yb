# yb - a bash yaml parser

`yb` provides a pure Bash solution to YAML parsing.

- [Usage](#usage)
- [Installation](#installation)
- [API](#api)
- [Development](#development)

## Usage

```bash
./yb -aAcdFlLnqRrT -f "<yaml_file>" -k "<key>" -v "<value>"
```

### Examples

```bash
./yb -f file.yaml -k "key.childkey"
```

From the repository, you can do a quick try like so:
```bash
./yb -f ./tests/user.yaml -k "yb"
```

Create keys:
```bash
./yb -af ./tests/user.yaml -k "new.key"
```

add inline-values:
```bash
./yb -af ./tests/user.yaml -k "new.key" -v "one, two"
```

add list-values:
```bash
./yb -af ./tests/user.yaml -k "new.- list" -v "- one - two"
```

add an ASCII within a pipe-key:
```bash
./yb -af ./tests/user.yaml -k "new.ascii|" -v "|>  ___  _ |>  \  \// |>   \  / |>   / / |>  /_/"
```

And remove everything:
```bash
./yb -rf ./tests/user.yaml -k "new"
```

## Installation

### One-liner

You can use this command to install yb on your system in one line:

```bash
bash <(echo "https://gitlab.com/t0pd4wn/yb/-/raw/main/yb"|(read l; wget $l || curl $l >yb)) && chmod +x yb && sudo cp yb /usr/local/bin;
```

### From the repository

```bash
git clone [yb_repo]
cd yb
chmod +x yb
```

`yb` can then be used directly from the repository folder or copied and used as a single file within a project.

### From an url

You can use this command to dowload directly the `yb` script where needed:

```bash
bash <(echo https://gitlab.com/t0pd4wn/yb/-/raw/main/yb|(read l; wget $l || curl $l >yb)) && chmod +x yb;
```

If you want `yb` to be available system wide, run this command from the repository folder:

```bash
sudo cp yb /usr/local/bin/
```

## Options API

`yb` options API is divided under 3 types:
- `action`: action options are ran against the file and are not compatible with each others. They are compatible with `input`, but not `format`.
- `input`: input options are user settable options, and are compatible with each others. They are compatible with both `action` and `format`.  
- `format`: format options are printing the output in various ways. They are compatible with each others, with `input` , but not `action`.

| Option | Name | Type | Description | Example | Notes |
| ------ | ------ | ------ | ------ | ------ | ------ |
| `-a`   | add    | action | Adds key(s), value(s) or both. | `yb -f "file.yaml" -a -k "key" -v "value"` | |
| `-c`   | change | action | Changes value(s). | `yb -f "file.yaml" -c -k "key" -v "new_value"` | |
| `-q`   | query  | action | Prints `true` or `false` if key(s), value(s) or both are present or not. | `yb -f "file.yaml" -q -k "key"` |        |
| `-r`   | remove | action | Removes key(s), value(s) or both. | `yb -f "file.yaml" -r -k "key" -v "value"` | |
| `-f`   | file   | input  | YAML file path. | `yb -f "file.yaml"`| A file can be presented without the `-f` option, as the `$1` option. `-f` and `-c` are not compatible with each others. |
| `-k`   | key    | input  | Key(s) selection path. | `yb -f "file.yaml" -k "key"` | Support keys in this format :`key`, `key.childkey`, `- list-key`, `pipe-key\|`. Multiple key(s) can be provided with a `.` as the separator.|
| `-v`   | value  | input  | Value(s) to be added, removed, queried or changed. | `yb -f "file.yaml" -k "key" -v "value"` | Support values in this format : `value`,  `- list-value`, `\|> pipe-value`. |
| `-A`   | array  | format | Prints the output as a bash array. | `yb -f "file.yaml" -A -k "key"` | Will provide a different formatting if used with `-F` or `-d`. |
| `-d`   | depth  | format | Provides the output with original depth. | `yb -f "file.yaml" -d -k "key.childkey" -v "new_value"`  |        |
| `-F`   | format | format | Prints a formatted output to represent the arborescence inline. | `yb -f "file.yaml" -F -k "key"` | Will provide a different formatting if used with `-A` or `-d`. |
| `-l`   | line   | format | Prints `{{line}}` on each lines. | `yb -f "file.yaml" -l -k "key"` | |
| `-L`   | level  | format | Prints `{{<level number>}}` on each lines. | `yb -f "file.yaml" -L -k "key"` | |
| `-R`   | raw    | format | Prints the ouptut without added colors. | `yb -f "file.yaml" -R -k "key"` | |
| `-n`   | number | format | Prints `{{<line number>}}` on each lines. | `yb -f "file.yaml" -n -k "key"` | |
| `-T`   | type   | format | Prints a value type. | `yb -f "file.yaml" -T -k "key"` | Supports `null`, `boolean`, `integers`, `floating numbers`, `string`. |
| `-s`   | spaces | Deprecated | Spaces number selection. | | |

## Development

Full sources are made available in the `/src/` folder. The version present at the root level is built with the `/src/tools/yb_minify.sh` script.

### Tests

A simple test suite is made available in the `tests/` folder. It introduces the various `yb` use cases.

To launch it, run the below command from the repository root level :
```bash
./tests/yb_test.sh
```

## License

Licensed under the MIT license.

## Thank you

***All of you, YAML'ers !***

Made in Bash.