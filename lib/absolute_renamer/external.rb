require 'absolute_renamer/imodule'
require 'absolute_renamer/iplugin'
require 'absolute_renamer/use_config'

begin
    require 'rubygems'
rescue LoadError
end

module AbsoluteRenamer
    # Class in charge of loading external modules.
    class External
        class << self
            include AbsoluteRenamer::UseConfig

            def load_gems
                if Gem
                    @gems = {}

                    find_gems
                    find_gems_from_conf

                    @gems.each do |gem_name, gem_infos|
                        gem gem_name, gem_infos[:version]
                        require gem_infos[:lib]
                    end
                end
            end

            def find_gems
                installed_gems = Gem.source_index.find_name(/.*AbsoluteRenamer-.*/).map(&:name).uniq || []
                p installed_gems
                installed_gems.each do |gem_name|
                    @gems[gem_name] = { :lib => gem_name, :version => '>= 0' }
                end
            end

            def find_gems_from_conf
                if conf[:gems]
                    conf[:gems].each do |gem_name, gem_infos|
                        @gems[gem_name] = gem_infos ||= {}
                        @gems[gem_name][:lib] ||= gem_name
                        @gems[gem_name][:version] ||= ">= 0"
                    end
                end
            end

            def load_core
                require 'absolute_renamer/core-packages/core-packages'
            end
        end
    end
end
