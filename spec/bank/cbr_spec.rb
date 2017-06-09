require "spec_helper"

describe Money::Bank::Cbr do
  describe '.rates' do
    it 'today rates' do
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

      WebMock
        .stub_request(:get, "http://www.cbr.ru/scripts/xml_daily.asp?date_req=09.06.2017")
        .to_return(status: 200, body: xml)

      rates = Money::Bank::Cbr.new.rates
      expect(rates['RUBAUD']).to eql(43.0185)
      expect(rates['AUDRUB'].round(2)).to eql((1 / 43.0185).round(2))
      expect(rates['RUBHKD']).to eql(73.0914)
      expect(rates['HKDRUB'].round(2)).to eql((1 / 73.0914).round(2))
    end
  end
end
