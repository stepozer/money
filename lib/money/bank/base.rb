module Money
  module Bank
    class Base
      def self.singleton
        @singleton ||= self.new
      end

      def initialize
        @rates = fetch_rates
      end

      def add_rate(from, to, rate)
        @rates["#{from}#{to}"] = rate
      end

      def rate(from, to)
        @rates["#{from}#{to}"]
      end
    end
  end
end
