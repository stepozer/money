require "spec_helper"

describe Money::Bank::Cbr do
  describe '.rates' do
    it 'without cache' do
      xml = <<-HEREXML
        <?xml version="1.0" encoding="windows-1251" ?>
        <ValCurs Date="09.06.2017" name="Foreign Currency Market">
        <Valute ID="R01010">
          <NumCode>036</NumCode>
          <CharCode>AUD</CharCode>
          <Nominal>1</Nominal>
          <Name>Австралийский доллар</Name>
          <Value>43,0185</Value>
        </Valute>
        <Valute ID="R01200">
          <NumCode>344</NumCode>
          <CharCode>HKD</CharCode>
          <Nominal>10</Nominal>
          <Name>Гонконгских долларов</Name>
          <Value>73,0914</Value>
        </Valute>
      HEREXML

      date = Date.today
      url  = "http://www.cbr.ru/scripts/xml_daily.asp?date_req=#{date.strftime("%d.%m.%Y")}"
      WebMock
        .stub_request(:get, url)
        .to_return(status: 200, body: xml)
      allow(Money::Cache::File).to receive(:get).and_return(nil)

      rates = Money::Bank::Cbr.new.rates
      expect(rates['RUBAUD'].round(2)).to eql((1 / 43.0185).round(2))
      expect(rates['AUDRUB']).to eql(43.0185)
      expect(rates['RUBHKD'].round(2)).to eql((1 / 73.0914 * 10).round(2))
      expect(rates['HKDRUB']).to eql(73.0914 / 10)
      expect(WebMock).to have_requested(:get ,url)
    end

    it 'from cache' do
      date = Date.today
      url  = "http://www.cbr.ru/scripts/xml_daily.asp?date_req=#{date.strftime("%d.%m.%Y")}"

      allow(Money::Cache::File).to receive(:get).and_return({ "AUDRUB" => 43.0185})

      rates = Money::Bank::Cbr.new.rates
      expect(rates['AUDRUB']).to eql(43.0185)
      expect(WebMock).to_not have_requested(:get ,url)
    end
  end
end
