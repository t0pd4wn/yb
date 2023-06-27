# yb - a bash yaml parser

This is an effort at providing a pure bash solution to the yaml parsing problem. It proposes an iterative approach based on IFS. ***Currently in its early prototyping.***

## Usage:

```bash
./yb -FRAlnd -f <yaml_file> -k <key> -s <spacer_value>
```

Example:

```bash
./yb -f file.yaml -k "key.childkey"
```

## Tests:

A simple test suit is made available through a `yb.yaml` and `yb_test.sh` files in the `tests/` folder.

To launch them, run the below command from the repository root level :
```bash
./tests/yb_test.sh   
```

## Todo:

- [x] `<key>` selection
- [x] `<key.childkey>` selection
- [ ] `<key` perimeter operators options
- [x] `-f` file option 
- [ ] `-a` add option 
- [ ] `-r` remove option
- [x] `-k` key selection
- [x] `-R` raw option (no colors code in the output)
- [x] `-d` depth option (keep orginal depth)
- [x] `-F` format option
- [x] `-A` array option (needs -F)
- [x] `-l` line spacer option
- [x] `-n` line number spacer option
- [x] `-s` spacer option
- [ ] `-v` value option (limit to value(s))
- [ ] `-w` write to file option
- [ ] `---` group selection support
- [ ] complex sets and mappings

## License

Licensed under the MIT license.

Made in Bash.