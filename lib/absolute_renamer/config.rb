require 'yaml'

module AbsoluteRenamer
    # Class handeling the configuration.
    class Config
        class << self
            # Open and load a Yaml file into the +@conf+ variable.
            # config_path: path of the file to load.
            def load(config_path)
                @conf ||= {}

                if tmp_conf = YAML::load_file(config_path)
                  @conf.deep_merge! tmp_conf
                end

                @conf[:options] ||= {}
                @conf[:options][:format] ||= '$'
                @conf[:options][:ext_format] ||= '$'
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