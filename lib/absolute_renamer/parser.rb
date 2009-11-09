require 'optparse'
require 'absolute_renamer/iparser'
require 'absolute_renamer/use_config'
require 'pp'

module AbsoluteRenamer
    # Class in charge of the command line parsing.
    class Parser
        class << self
            include AbsoluteRenamer::UseConfig

            # Calls all registred parsers.
            # The parsers are written in configuration files.
            # The core parsers are automaticaly added.
            def parse_cmd_line
                ARGV.options do |parser|
                    begin
                        list = AbsoluteRenamer::IParser.children
                        list.each do |class_name|
                            class_name.add_options(parser, conf[:options])
                        end
                        parser.parse!
                    rescue RuntimeError => ex
                        STDERR.puts(ex)
                        exit 1
                    end
                    conf[:files] = self.get_files(ARGV, 0) || []
                    pp conf.get if conf[:debug]
                end
            end

            # Creates a list of all files and directories to rename.
            # All options that have not been matched are considered as path.
            # For directories, if the recursive otpion is set to true (conf[:rec] == true),
            # files are searched in sub directories.
            #
            # list: a list of path to explore
            # depth: maximum recursion depth
            #
            # Returns the files/directories list
            def get_files(list, depth)
                files   = []
                options = conf[:options]

                list.each do |entry|
                    if File.exists?(entry)
                        is_dir   = File.directory?(entry)
                        mod_dir  = options[:dir]
                        depth_ok = (depth < options[:maxdepth] or options[:maxdepth].zero?)
                        mod_rec  = (options[:rec] and depth_ok)

                        add_dir  = (is_dir and mod_dir)
                        add_file = (!is_dir and !mod_dir)
                        add_sub  = (is_dir and (mod_rec or (!mod_dir and depth < 1)))

                        files << FileInfo.new(entry) if (add_dir or add_file)
                        files += self.get_files(self.get_subentries(entry), depth + 1) if (add_sub)
                    end
                end

                files
            end

            # Returns files and directories contained in +path+.
            def get_subentries(path)
                files = Dir.entries(path)
                files.delete_if { |file| file[0,1] == '.' }
                files.collect!  { |file| File.join(path, file) }
            end
        end
    end
end
