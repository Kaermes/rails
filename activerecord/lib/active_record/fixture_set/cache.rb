
module ActiveRecord
  class FixtureSet
    class Cache # :nodoc:

      #TODO: Fix directory to Rails.root/tmp
      def self.cache_fixtures(cache_name, fixtures)
        ::File.open("/tmp/#{cache_name}", ::File::RDWR|::File::TRUNC|::File::CREAT) do |file|
          file.write(Marshal.dump(fixtures))
        end
      end

      def self.last_time_modified(cache_name)
        if ::File.exists?("/tmp/#{cache_name}")
          ::File.mtime("/tmp/#{cache_name}")
        else
          nil
        end
      end

      def self.read_cached_fixture(cache_name)
        Marshal.load(::File.read("/tmp/#{cache_name}"))
      end

      def self.fixture_newer_than_cache?(path_to_fixture, cache_name)
        FixtureSet::File.open(path_to_fixture) do |fh|
          fixture_modified_time = last_time_modified(cache_name)
          if fixture_modified_time
            fh.newer_than?(fixture_modified_time)
          else
            true
          end
        end
      end

    end
  end
end
