$:.unshift(File.dirname(__FILE__))

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
      # Asks to each module if it as something to replace
      # in the name of each file.
      #
      # Calls the +before_names_generation+ entry point.
      def create_names_list
        call_entry_point(:before_names_generation)

        name_format = conf[:options][:format]
        ext_format  = conf[:options][:ext_format]

        conf[:files].each do |file|
          do_replacements(file.name, :before)
          name, ext = AbsoluteRenamer::IModule.process(file, name_format.clone, ext_format.clone)
          do_replacements(name, :after)

          file.new_name = name
          file.new_name << ".#{ext}" unless (file.dir or file.ext.empty? or conf[:options][:no_ext])
        end

        conf[:files].sort! if (conf[:options][:dir] and conf[:options][:rec])
      end

      # For each file/dir replaces his name by his new name.
      #
      # Calls the following entry points :
      #   - before_batch_renaming ;
      #   - before_file_renaming ;
      #   - after_file_renaming ;
      #   - after_batch_renaming.
      def do_renaming
        surround_with_entry_points(:batch_renaming) do
          conf[:files].each do |file|
            surround_with_entry_points(:file_renaming, :file => file) do
              file.send(conf[:options][:mode]) if file.respond_to? conf[:options][:mode]
              {:file => file}
            end
          end
        end
      end

      # Loads the plugins list in the @plugins variable.
      def load_plugins
        @plugins = {}
        AbsoluteRenamer::IPlugin.children.each do |plugin|
          @plugins[plugin.symbol] = plugin.new
        end
      end

      def surround_with_entry_points(ep, params = nil)
        if call_entry_point("before_#{ep}".to_sym, params)
        result = yield
        call_entry_point("after_#{ep}".to_sym, result)
        end
      end

      # Calls the given entry point for each plugin available
      #
      # Ask to each plugin if it implements the entry point
      # and calls it with params if it isn't null.
      # It keeps going while all plugins return true.
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
