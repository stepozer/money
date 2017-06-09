# Money

A Library for money and currency conversion.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'money', :git => 'git://github.com/stepozer/money.git'
```

And then execute:

    $ bundle

## Usage

``` ruby
require 'money'

# 10.00 USD
money = Money::Coin.new(1000, "USD")
money.amount    #=> 1000
money.currency  #=> "USD"

# Arithmetic operations
Money::Coin.new(1000, "USD") + Money::Coin.new(500, "USD") #=> Money::Coin.new(1500, "USD")
Money::Coin.new(1000, "USD") - Money::Coin.new(200, "USD") #=> Money::Coin.new(800, "USD")
Money::Coin.new(1000, "USD") / 5                           #=> Money::Coin.new(200, "USD")
Money::Coin.new(1000, "USD") * 5                           #=> Money::Coin.new(5000, "USD")

# Currency conversions
Money::Coin.new(1000, "USD").convert("EUR")
Money::Coin.new(1000, "USD").convert_multiple(["EUR", "USD"])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stepozer/money.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

