require 'net/http'
require 'nori'
require 'digest/md5'
require 'money/version'
require 'money/cache/file'
require 'money/bank/base'
require 'money/bank/dummy'
require 'money/bank/crb'

module Money
  class Coin
    attr_reader :currency, :amount

    def initialize(amount, currency, bank = Money::Coin.default_bank)
      @amount   = amount
      @currency = currency
      @bank     = bank
    end

    def convert(new_currency)
      if self.currency == new_currency
        self
      else
        self.class.new(@amount * @bank.rate(currency, new_currency), new_currency)
      end
    end

    def convert_multiple(new_currencies)
      new_currencies.map { |c| self.convert(c) }
    end

    def +(money)
      money = money.convert(currency)
      self.class.new((amount + money.amount), currency)
    end

    def -(money)
      money = money.convert(currency)
      self.class.new((amount - money.amount), currency)
    end

    def *(m_amount)
      self.class.new((amount * m_amount), currency)
    end

    def /(m_amount)
      self.class.new((amount / m_amount), currency)
    end

    def self.default_bank
      Money::Bank::Cbr.singleton
    end

    def to_s
      "#{@amount.round(2)} #{@currency}"
    end
  end
end
