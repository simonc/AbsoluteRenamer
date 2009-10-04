$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'absolute_renamer/config'
require 'absolute_renamer/with_children'
require 'absolute_renamer/external'
require 'absolute_renamer/parser'
require 'absolute_renamer/file_info'
require 'absolute_renamer/libs/file'
require 'absolute_renamer/libs/string'
require 'absolute_renamer/libs/hash'
require 'absolute_renamer/use_config'

# top level module of AbsoluteRenamer.
module AbsoluteRenamer
    version_file_path = File.join(File.dirname(__FILE__), '/../VERSION')
    File.open(version_file_path) do |f|
        VERSION = f.read
    end

    # The main class of AbsoluteRenamer.
    #
    # Organizes the files and directories renaming process.
    class Processor
        class << self
            include AbsoluteRenamer::UseConfig

            # Creates the new names for each file passed to AbsoluteRenamer.
            #
            # Asks to each module if he as something to replace
            # in the name of each file.
            #
            # Calls the +before_names_generation+ entry point.
            def create_names_list
                call_entry_point(:before_names_generation)
                return if conf[:files].empty?
                mods = {}
                conf[:files].each do |file|
                    name = conf[:options][:format].clone
                    ext = conf[:options][:ext_format].clone
                    do_replacements(file.name, :before)
                    AbsoluteRenamer::IModule.children.each do |mod|
                        mod_sym = mod.symbol
                        mods[mod_sym] ||= mod.new
                        name = mods[mod_sym].process(file, name)
                        ext = mods[mod_sym].process(file, ext, :ext) unless file.dir
                    end
                    do_replacements(name, :after)
                    file.new_name = name
                    file.new_name << '.' << ext unless (file.dir or file.ext.empty?)
                end
                if (conf[:options][:dir] and conf[:options][:rec])
                  conf[:files].sort! { |a, b| AbsoluteRenamer::FileInfo.compare_level(a, b) }
                end
                mods.clear
            end

            # For each file/dir replaces his name by his new name.
            #
            # Calls the following entry points :
            #   - before_batch_renaming ;
            #   - before_file_renaming ;
            #   - after_file_renaming ;
            #   - after_batch_renaming.
            def do_renaming
                if call_entry_point(:before_batch_renaming)
                    conf[:files].each do |file|
                        if call_entry_point(:before_file_renaming, :file => file)
                            if file.respond_to?(conf[:options][:mode])
                                file.send(conf[:options][:mode])
                            end
                            call_entry_point(:after_file_renaming, :file => file)
                        end
                    end
                    call_entry_point(:after_batch_renaming)
                end
            end

            # Loads the plugins list in the @plugins variable.
            def load_plugins
                @plugins = {}
                AbsoluteRenamer::IPlugin.children.each do |plugin|
                    @plugins[plugin.symbol] = plugin.new
                end
            end

            # Calls the given entry point for each plugin available
            #
            # Ask to each plugin if it implements the entry point
            # and calls it with params if it isn't null.
            # It keeps going will all plugins return true.
            #
            # returns true if all plugins returned true
            def call_entry_point(ep, params = nil)
                puts "Plugin Entry Point: #{ep}" if conf[:debug]
                keep_going = true
                @plugins.each_value do |plugin|
                    if plugin.respond_to?(ep)
                        keep_going &= params.nil? ? plugin.send(ep) : plugin.send(ep, params)
                    end
                end
                keep_going
            end

            # Applies replacements
            #
            # The replacements are stored in conf[options][replacements][moment]
            # and are provided as command line paramters.
            #
            # format represents the string in which the replacements are done
            # moment determines which replacements are done (on old or new name)
            def do_replacements(format, moment)
                begin
                    replacements = conf[:options][:replacements][moment]
                rescue NoMethodError
                    replacements = nil
                end
                unless replacements.nil?
                    replacements.each do |repl|
                        format.gsub!(repl[:pattern], repl[:replace])
                    end
                end
            end
        end
    end
end
