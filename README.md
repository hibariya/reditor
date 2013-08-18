# Reditor [![Build Status](https://travis-ci.org/hibariya/reditor.png?branch=master)](https://travis-ci.org/hibariya/reditor)

Reditor provides `reditor` command.

This command detect and open a library from $LOAD_PATH or rubygems.

reditor requires the EDITOR variable.

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'reditor'
```

And then execute:

```
  $ bundle
```

Or install it yourself as:

```
  $ gem install reditor
```

## Usage

### Open Standard Library (pure ruby only)

```
  $ reditor set
```

### Open a gem

```
  $ reditor mechanize
```

### Open a shell and move to the library.

```
  $ reditor sh mechanize
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
