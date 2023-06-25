# yb - yaml bash parser

This is an effort at providing a pure bash solution to the yaml parsing problem. It proposes an iterative approach based on IFS. ***Currently in its early prototyping.***

## Usage:

```bash
yb <yaml_file>
```

## Todo:

- [x] `<key>` selection
- [x] `<key.childkey>` selection
- [ ] `<key` perimeter options
- [x] `-f` file option 
- [ ] `-a` add option 
- [ ] `-r` remove option
- [x] `-k` key option (limit to key(s))
- [x] `-R` raw option (no formatting)
- [x] `-F` format option
- [x] `-A` array option (needs -F)
- [ ] `-v` value option (limit to value(s))
- [ ] `-w` write to file option
- [ ] `---` group selection support

## License

Licensed under the MIT license.