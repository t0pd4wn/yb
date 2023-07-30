# yb - a bash yaml parser

`yb` provides a pure bash solution to the yaml parsing problem.

## Usage:

```bash
./yb -aAdFlLnqRrT -f "<yaml_file>" -k "<key>" -v "<value>"
```

### Examples:

```bash
./yb -f file.yaml -k "key.childkey"
```

You can do a quick try like so:
```bash
./yb -f ./tests/user.yaml -k "yb"
```

Create keys:
```bash
./yb -af ./tests/user.yaml -k "new.key"
```

Add inline-values:
```bash
./yb -af ./tests/user.yaml -k "new.key" -v "one"
```

Or list-values:
```bash
./yb -af ./tests/user.yaml -k "new.list" -v "- one"
```

And remove everything:
```bash
./yb -rf ./tests/user.yaml -k "new"
```

## Tests:

A simple test suite is made available in the `tests/` folder. It introduces the various `yb` use cases.

To launch it, run the below command from the repository root level :
```bash
./tests/yb_test.sh
```

## Todo:

- [x] `-f` file option 
- [x] `-k <key>` selection
- [x] `-k <key.childkey>` selection
- [x] `-v` value option (supported for add)
- [x] `-a` add option
- [x] `-r` remove option
- [ ] `-c` change option
- [x] `-R` raw option (no color codes in the output)
- [x] `-d` depth option (keeps original depth)
- [x] `-F` format option
- [x] `-A` array option
- [x] `-l` line spacer option
- [x] `-L` level spacer option
- [x] `-n` line number spacer option
- [x] `-q` query option (check for keys path)
- [x] `-s` spaces indentation option (to be deprecated)
- [x] `-T` typing support (partial)
- [ ] `-t` color themes option
- [ ] `---` group selection support
- [ ] better escaping management
- [ ] complex sets and mappings
- [ ] error code propagation

## License

Licensed under the MIT license.

Made in Bash.