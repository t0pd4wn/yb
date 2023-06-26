# yb - a bash yaml parser

This is an effort at providing a pure bash solution to the yaml parsing problem. It proposes an iterative approach based on IFS. ***Currently in its early prototyping.***

## Usage:

```bash
./yb -FRA -f <yaml_file> -k <key> -s <spacer_value>
```

Example:

```bash
./yb -f file.yaml -k "key.childkey"
```

## Todo:

- [x] `<key>` selection
- [x] `<key.childkey>` selection
- [ ] `<key` perimeter operators options
- [x] `-f` file option 
- [ ] `-a` add option 
- [ ] `-r` remove option
- [x] `-k` key option (limit to key(s))
- [x] `-R` raw option (no colors code in the output)
- [x] `-F` format option
- [x] `-A` array option (needs -F)
- [x] `-l` line spacer option (needs -F)
- [x] `-L` line number spacer option (needs -F)
- [x] `-s` spacer option
- [ ] `-v` value option (limit to value(s))
- [ ] `-w` write to file option
- [ ] `---` group selection support
- [ ] complex sets and mappings

## License

Licensed under the MIT license.

Made in Bash.