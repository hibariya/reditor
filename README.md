# Reditor [![Build Status](https://travis-ci.org/hibariya/reditor.png?branch=master)](https://travis-ci.org/hibariya/reditor)

Reditor provides `reditor` command.

This command detect and open a library from $LOAD_PATH or rubygems.

reditor requires the EDITOR variable.

## Installation

```
  $ gem install reditor
```

## Usage

### Open a Standard Library (pure ruby only)

```
  $ reditor set
```

### Open a gem

```
  $ reditor railties
```

### Open a library with shell

```
  $ reditor sh railties
```

### Open a gem on bundler project

Reditor opens a gem that specified in Gemfile by default.
If you want to avoid it, pass the `--global' option.

```ruby
$ gem list rack

*** LOCAL GEMS ***

rack (1.5.2, 1.4.5)

$ bundle list rack
/(snip)/rack-1.4.5

$ reditor rack          # open rack-1.4.5
$ reditor rack --global # open rack-1.5.2
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
