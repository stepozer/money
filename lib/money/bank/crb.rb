module Money
  module Bank
    class Cbr < Base
      ENDPOINT = 'http://www.cbr.ru/scripts/xml_daily.asp?date_req=%{d}'

      def rates(date = nil)
        date ||= Date.today
        rates_xml = Net::HTTP.get(URI.parse(ENDPOINT % { d: date.strftime("%d.%m.%Y") }))

        Nori.new.parse(rates_xml).fetch('ValCurs').fetch('Valute').each do |x|
          value = x['Value'].gsub(/[,]/, '.').to_f / x['Nominal'].to_i
          add_rate('RUB', x['CharCode'], 1.0 / value)
          add_rate(x['CharCode'], 'RUB', value)
        end

        @rates
      end
    end
  end
end
