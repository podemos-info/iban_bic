# IBAN + BIC
When IBAN validation is not enough.

[![Gem](https://img.shields.io/gem/v/iban_bic.svg)](https://rubygems.org/gems/iban_bic)
[![Travis](https://img.shields.io/travis/podemos-info/iban_bic/master.svg)](https://travis-ci.org/podemos-info/iban_bic)
[![Codecov](https://img.shields.io/codecov/c/github/podemos-info/iban_bic.svg)](https://codecov.io/gh/podemos-info/iban_bic)
[![Scrutinizer](https://img.shields.io/scrutinizer/g/podemos-info/iban_bic.svg)](https://scrutinizer-ci.com/g/podemos-info/iban_bic/)
[![Dependency Status](https://www.versioneye.com/user/projects/59d393190fb24f0046190d85/badge.svg?style=flat-square)](https://www.versioneye.com/user/projects/59d393190fb24f0046190d85?style=flat)

## Features
* IBAN and BIC validation (using `ActiveModel::EachValidator`, IBAN control digits calculator function).
* National account digits control validation (currently only ES and PT are included, others countries can be added).
* IBAN fixing (global and national control digits).
* Associated tags to countries (currently only SEPA and FIXED_CHECK tags are available).
* BICs mapping from IBAN bank code part: COUNTRY + BANK => BIC code.
  * Currently, static data only includes some ES banks, PRs are welcomed.
* Optional database model to allow apps to dynamically add new BICs mapping.
* Random IBANs generator

## Usage

1. IBAN validator: add IBAN validation to your models.

```ruby
validates :iban, iban: true
```

You can also validate that IBAN is from a SEPA country.

```ruby
validates :iban, iban: { tags: [:sepa] }
```

2. BIC validator: add BIC validation to your models.

```ruby
validates :bic, bic: true
```

You can specify the country field in the record to enforce its inclusion in the given BIC.

```ruby
validates :bic, bic: { country: :pais }
```


3. IBAN control digits calculation

```ruby
2.4.1 :001 > IbanBic.calculate_check("ES0000030000300000000000")
 => 87
```

4. IBAN parsing

```ruby
2.4.1 :001 > IbanBic.parse("ES8700030000300000000000")
=> {"country"=>"ES", "iban_check"=>"87", "bank"=>"0003", "branch"=>"0000", "check"=>"30", "account"=>"0000000000"}
```

5. IBAN fixing (IBAN control digits and country control digits, if that code is available)

```ruby
2.4.1 :001 > IbanBic.fix("ES0000030000200000000000")
 => "ES8700030000300000000000"
```

6. BIC calculation (bank code must be in the static file or in the database)

```ruby
2.4.1 :001 > IbanBic.calculate_bic("ES8700030000300000000000")
 => "BDEPESM1XXX"
```

7. Pattern generation for SQL LIKE queries.

```ruby
2.4.1 :001 > IbanBic.like_pattern("ES8700030000300000000000", :country, :bank)
 => "ES__0003________________"
2.4.1 :002 > IbanBic.like_pattern_from_parts(country: "ES", bank: "0003")
 => "ES__0003________________"
```

8. Random IBAN generation

```ruby
2.4.1 :001 > require "iban_bic/random"
 => true
2.4.1 :002 > IbanBic.random_iban
 => "MU52BOIR2768144336487102000AWQ"
2.4.1 :003 > IbanBic.random_iban country: "ES"
 => "ES6111051493192369291292"
2.4.1 :004 > IbanBic.random_iban tags: [:sepa]
 => "FI5584518206233159"
2.4.1 :005 > IbanBic.random_iban not_tags: [:sepa]
 => "IL317532867920826062774"
```

Note: It can't generate a valid IBAN code for some countries where iban check digits are fixed if validation code for that country is not available.

## Installation

1. Add this line to your application's Gemfile

```ruby
gem "iban_bic"
```

2. Update bundle

```bash
$ bundle
```

3. If you will use this gem for BIC calculations or want to add additional country control codes validations, choose from any of the following two options to run the installer:

3.a. Using BICs dynamic data from database

Add a `bics` table to your database and an initializer file for configuration:

```bash
$ bundle exec rails generate iban_bic:install
$ bundle exec rake db:migrate
```

Load static data to the created `bics` table:

```bash
$ bundle exec rake iban_bic:load_data
```

3.b. Using static data from YAML files

Create an initializer file for configuration:
  
```bash
$ bundle exec rails generate iban_bic:install --with-static-data
```

4. Customize initializer if needed, adding validations for new countries, or overriding YAML files.

## Changelog
#### 1.4.0

* BIC validation moved from BIC model to an independent validator.

#### 1.3.0

* Added BIC format validation in BIC model.

#### 1.2.0

* Added `like_pattern_from_parts` method. Not a very performant version.
* Fixed portuguese IBAN validation.

#### 1.1.0

* Added `like_pattern` method.

#### 1.0.1

* Added presence validations in BIC model.

#### 1.0.0

* Added IBAN fixing and random IBAN generator.

* Changed country checks, they must change check parts to generate the correct IBAN. Comparison against the original IBAN is made by the caller.

#### 0.1.0

* First version.

## Contributing
Issues and PRs are welcomed.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
