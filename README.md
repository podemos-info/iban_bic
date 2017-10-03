# IBAN + BIC
When IBAN validation is not enough.

[![Travis](https://img.shields.io/travis/podemos-info/iban_bic/master.svg)](https://travis-ci.org/podemos-info/iban_bic)
[![Codecov](https://img.shields.io/codecov/c/github/podemos-info/iban_bic.svg)](https://codecov.io/gh/podemos-info/iban_bic)
[![Scrutinizer](https://img.shields.io/scrutinizer/g/podemos-info/iban_bic.svg)](https://scrutinizer-ci.com/g/podemos-info/iban_bic/)
[![Dependency Status](https://www.versioneye.com/user/projects/59d393190fb24f0046190d85/badge.svg?style=flat-square)](https://www.versioneye.com/user/projects/59d393190fb24f0046190d85?style=flat)

## Features
* IBAN validation (`ActiveModel::EachValidator` and control digits calculator function)
* National account digits control validation (currently only ES included, others countries can be added).
* BICs mapping from IBAN bank code part: COUNTRY + BANK => BIC code
  * Currently, static data only includes some ES banks, PRs are welcomed.
* Optional database model to allow apps to dynamically add new BICs mapping.

## Installation

1. Add this line to your application's Gemfile

    ```ruby
    gem "iban_bic"
    ```

2. Update bundle
    ```bash
    $ bundle
    ```

3. Run installer 

3.1. Using BICs dynamic data from database

    Add a `bics` table to your database and an initializer file for configuration:

    ```bash
    bundle exec rails generate iban_bic:install
    bundle exec rake db:migrate
    ```

    Load static data to the created `bics` table:

    ```bash
    bundle exec rake iban_bic:load_data
    ```

3.2. Using static data from YAML files

    Create an initializer file for configuration:
  
    ```
    bundle exec rails generate iban_bic:install --with-static-data
    ```

4. Customize initializer if needed, adding validations for new countries, or overriding YAML files.

## TO-DO

* Faker data generation

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
