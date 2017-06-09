module Money
  module Bank
    class Dummy < Base
      def fetch_rates
        {}
      end
    end
  end
end
