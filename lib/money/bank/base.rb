module Money
  module Bank
    class Base
      def initialize
        @rates = {}
      end

      def self.singleton
        @singleton ||= self.new
      end

      def add_rate(from, to, rate)
        @rates["#{from}#{to}"] = rate
      end

      def rate(from, to)
        rates.fetch("#{from}#{to}")
      end
    end
  end
end
