module Money
  module Bank
    class Cbr < Base
      ENDPOINT = 'http://www.cbr.ru/scripts/xml_daily.asp'

      def fetch_rates
        Net::HTTP.get(URI.parse(ENDPOINT))
      end
    end
  end
end
