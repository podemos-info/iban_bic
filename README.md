# IbanBic
When IBAN validation is not enough.

[![Travis](https://img.shields.io/travis/podemos-info/iban_bic/master.svg)](https://travis-ci.org/podemos-info/iban_bic)
[![Codecov](https://img.shields.io/codecov/c/github/podemos-info/iban_bic.svg)](https://codecov.io/gh/podemos-info/iban_bic)
[![Scrutinizer](https://img.shields.io/scrutinizer/g/podemos-info/iban_bic.svg)](https://scrutinizer-ci.com/g/podemos-info/iban_bic/)
[![Dependency Status](https://www.versioneye.com/user/projects/59d393190fb24f0046190d85/badge.svg?style=flat-square)](https://www.versioneye.com/user/projects/59d393190fb24f0046190d85?style=flat)

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'iban_bic'
```

And then execute:
```bash
$ bundle
```

1. Using BICs dynamic data from database

Add a `bics` table to your database and an initializer file for configuration:

    ```
    bundle exec rails generate iban_bic:install
    bundle exec rake db:migrate
    ```

Load static data to the created `bics` table:

    ```
    bundle exec rake iban_bic:load_data
    ```

1. Using static data from YAML files

Create an initializer file for configuration:

    ```
    bundle exec rails generate iban_bic:install --with-static-data
    ```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
