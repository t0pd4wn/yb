# yb - a bash yaml parser

`yb` provides a pure bash solution to the yaml parsing problem. *Currently in its early prototype version.*

## Usage:

```bash
./yb -FRAlLndq -f <yaml_file> -k <key> -s <spacer_value>
```

Example:

```bash
./yb -f file.yaml -k "key.childkey"
```

You can do a quick try like so:
```bash
./yb -f ./tests/yb.yaml -k "yb"
```

## Tests:

A simple test suit is made available in the `tests/` folder. It presents the various `yb` use cases.

To launch it, run the below command from the repository root level :
```bash
./tests/yb_test.sh
```

## Todo:

- [x] `<key>` selection
- [x] `<key.childkey>` selection
- [ ] `<key` perimeter operators options
- [x] `-f` file option 
- [~] `-a` add option (currently being implemented, keys are ok)
- [ ] `-r` remove option
- [x] `-k` key selection
- [x] `-R` raw option (no colors code in the output)
- [x] `-d` depth option (keep orginal depth)
- [x] `-F` format option
- [x] `-A` array option
- [x] `-l` line spacer option
- [x] `-L` level spacer option
- [x] `-n` line number spacer option
- [x] `-q` query option (check for keys path)
- [x] `-s` spaces indentation option (in case your file has 4 spaces indentation)
- [ ] `-v` value option (limit to value(s))
- [ ] `-w` write to file option
- [ ] `-t` color themes option
- [ ] `---` group selection support
- [ ] complex sets and mappings
- [ ] error code propagation
- [ ] improve nested keys support

## License

Licensed under the MIT license.

Made in Bash.