require 'yaml'

module AbsoluteRenamer
  # Class handeling the configuration.
  class Config
    class << self
      # Opens and loads a list of Yaml files into the +@conf+ variable.
      # config_paths: list of files to load.
      def load(config_paths)
        @conf ||= {
          :options => {
            :ext_format   => '$',
            :format       => '$',
            :interactive  => :never,
            :maxdepth     => 0,
            :mode         => :rename
          }
        }

        config_paths.each do |conf_file|
          if File.exists?(conf_file)
            @conf.deep_merge!(tmp_conf) if tmp_conf = YAML::load_file(config_path)
          end
        end
      end

      # Returns a configuration value identified by +key+.
      # If +key+ is ignored, returns the +@conf+ hash.
      def get(key = nil)
        return @conf[key] if (key and @conf.has_key?(key))
        return @conf if key.nil?
      end

      # Sets a configuration value in the +@conf+ variable.
      def set(key, value = '')
        @conf[key] = value unless key.nil?
      end

      # Returns a configuration value identified by +key+.
      def [](key)
        @conf[key]
      end

      # Sets a configuration value in the +@conf+ variable.
      def []=(key, value)
        @conf[key] = value
      end
    end
  end
end
