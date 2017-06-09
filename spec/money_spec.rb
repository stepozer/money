require "spec_helper"

describe Money do
  it "has a version number" do
    expect(Money::VERSION).not_to be nil
  end

  describe '.new' do
    it 'initialize amount and currency' do
      m = Money::Coin.new(100, 'USD')
      expect(m.amount).to eql(100)
      expect(m.currency).to eql('USD')
    end
  end

  describe '.default_bank' do
    it 'check default bank' do
      expect(Money::Coin.default_bank).to eql(Money::Bank::Cbr.singleton)
    end
  end

  describe '.to_s' do
    it 'return string representation' do
      expect(Money::Coin.new(100, 'USD').to_s).to eql('100.0 USD')
      expect(Money::Coin.new(100.1, 'RUB').to_s).to eql('100.1 RUB')
    end
  end

  describe '.convert' do
    it 'same currency' do
      expect(Money::Coin.new(100, 'USD').convert('USD').to_s).to eql('100.0 USD')
    end

    it 'convert' do
      bank = Money::Bank::Dummy.new
      bank.add_rate('USD', 'RUB', 50.0)
      bank.add_rate('RUB', 'USD', 1.0/50.0)
      expect(Money::Coin.new(1.1, 'USD', bank).convert('RUB').to_s).to eql('55.0 RUB')
      expect(Money::Coin.new(55, 'RUB', bank).convert('USD').to_s).to eql('1.1 USD')
    end
  end

  describe '.convert_multiple' do
    it 'one currency' do
      bank = Money::Bank::Dummy.new
      bank.add_rate('USD', 'RUB', 50.0)
      expect(Money::Coin.new(1.1, 'USD', bank).convert_multiple(['RUB']).map(&:to_s)).to eql(['55.0 RUB'])
    end

    it 'multiple currencies' do
      bank = Money::Bank::Dummy.new
      bank.add_rate('USD', 'RUB', 50.0)
      bank.add_rate('USD', 'UAH', 25.0)
      result = Money::Coin.new(1.1, 'USD', bank).convert_multiple(['USD', 'RUB', 'UAH'])
      expect(result.map(&:to_s)).to eql(['1.1 USD', '55.0 RUB', "27.5 UAH"])
    end
  end

  describe '.+' do
    it 'same currency' do
      expect((Money::Coin.new(1, 'USD') + Money::Coin.new(2.3, 'USD')).to_s).to eql('3.3 USD')
      expect((Money::Coin.new(1.1, 'USD') + Money::Coin.new(2.3, 'USD')).to_s).to eql('3.4 USD')
    end

    it 'different currency' do
      bank = Money::Bank::Dummy.new
      bank.add_rate('RUB', 'USD', 1.0/50.0)
      expect((Money::Coin.new(1.1, 'USD') + Money::Coin.new(50, 'RUB', bank)).to_s).to eql('2.1 USD')
    end
  end

  describe '.-' do
    it 'same currency' do
      expect((Money::Coin.new(1, 'USD') - Money::Coin.new(2.3, 'USD')).to_s).to eql('-1.3 USD')
      expect((Money::Coin.new(1.1, 'USD') - Money::Coin.new(2.3, 'USD')).to_s).to eql('-1.2 USD')
    end

    it 'different currency' do
      bank = Money::Bank::Dummy.new
      bank.add_rate('RUB', 'USD', 1.0/50.0)
      expect((Money::Coin.new(1.1, 'USD') - Money::Coin.new(50, 'RUB', bank)).to_s).to eql('0.1 USD')
    end
  end
end
