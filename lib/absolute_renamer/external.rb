require 'absolute_renamer/imodule'
require 'absolute_renamer/iplugin'
require 'absolute_renamer/use_config'

module AbsoluteRenamer
    # Class in charge of loading +modules+ and +plugins+.
    class External
        class << self
            include AbsoluteRenamer::UseConfig

            # Loads the additional and core modules.
            # The modules list is get from the conf[:modules] variable.
            # The core modules are loaded after the additional ones.
            #
            # See also load
            def load_modules
                puts "[Loading modules]" if conf[:debug]

                modules = conf[:modules]
                load(modules, :modules, 'module.rb') unless modules.nil?

                core_modules = ['case', 'general'].map! { |core_module| File.join('core', core_module) }
                load(core_modules, :modules, 'module.rb')
            end

            # Loads the plugins.
            # The plugins list is get from the conf[:plugins] variable.
            #
            # See also load
            def load_plugins
                puts "[Loading plugins]" if conf[:debug]

                load(conf[:plugins], :plugins, 'plugin.rb')
            end

            # Loads an external list (+modules+ or +plugins+)
            # externals: a list of +externals+ names to load.
            # type: a symbol defining which type of external to load
            # file: the filename to require to load the +externals+
            def load(externals, type, file)
                ext_dir = conf[:path][type]

                externals.each do |external|
                    ext_to_load = File.join(ext_dir, external, file)
                    begin
                        if require ext_to_load
                            puts "Loaded: #{ext_to_load}" if conf[:debug]
                        end
                    rescue LoadError => e
                        STDERR.puts(e)
                    end
                end
            end
        end
    end
end
