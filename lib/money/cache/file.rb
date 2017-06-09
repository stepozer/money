module Money
  module Cache
    class File
      def self.set(key, value)
        f = ::File.open(get_path(key), 'w')
        ::Marshal.dump(value, f)
        f.close
      end

      def self.get(key)
        path = get_path(key)
        if ::File.exist?(path)
          f = ::File.open(path, "r")
          result = ::Marshal.load(f)
          f.close
          result
        else
          nil
        end
      end

      def self.get_or_set(key)
        value = get(key)
        return value if value
        value = yield
        set(key, value)
        value
      end

      def self.get_path(key)
        md5 = Digest::MD5.hexdigest(key.to_s).to_s
        "/tmp/#{md5}"
      end
    end
  end
end
