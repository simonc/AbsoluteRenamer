require 'ftools'
require 'fileutils'
require 'absolute_renamer/use_config'
require 'absolute_renamer/libs/file'

module AbsoluteRenamer
  # Class that represents each file to be renamed.
  # It contains all informations about a file and, in the end,
  # processes to its renaming.
  class FileInfo
    include AbsoluteRenamer::UseConfig

    attr_accessor :name, :new_name,
                  :path, :real_path,
                  :ext, :dir, :dir_path,
                  :level

    # Initializes a FileInfo.
    # path: the relative or absolute path of the file.
    def initialize(path)
      @path = path
      @real_path = File.expand_path(@path)
      @dir_path = File.dirname(@real_path)
      @dir = File.directory?(@real_path)
      @name = File.basename(@real_path)
      unless @dir
        @ext = File.extname(@name, conf[:options][:dots])
        @name.gsub!(Regexp.new('.' << Regexp.escape(@ext) << '$'), '') unless @ext.empty?
        @level = 0
      else
        @level = @real_path.split('/').size
      end
    end

    # Returns a description of a FileInfo
    #   some_fileinfo.inspect       # => "File: hello_world pdf"
    def inspect
      "File: #{@name} #{@ext}"
    end

    # Displays the action that will be done on the file.
    #   some_fileinfo.display_change  # => "rename a_file.txt --> A_File.TXT"
    def display_change
      puts "#{color conf[:options][:mode]} #{@real_path.sub(Dir.pwd+'/', '')} #{color '-->'} #{new_path.sub(Dir.pwd+'/', '')}"
    end

    # Returns a text colorized in red.
    #   color('hello')          #=> "\e[31mhello\e[0m"
    def color(text)
      "\e[31m#{text}\e[0m"
    end

    # Returns the new path of the file.
    def new_path
      if conf[:options][:dest].nil? or conf[:options][:dest].empty?
        File.join(@dir_path, @new_name)
      else
        File.join(conf[:options][:dest], @new_name)
      end
    end

    # Renames the file.
    def rename
      display_change
      File.rename(@real_path, new_path)
    end

    # Copies the file.
    def copy
      display_change
      if @dir
        if @real_path != conf[:options][:dest]
          FileUtils.cp_r(@real_path, conf[:options][:dest])
        else
          puts "#{real_path} ignored"
        end
      else
        File.copy(@real_path, new_path, false)
      end
    end

    # Moves a file. Moving to the same directories is just like renaming.
    def move
      display_change
      File.move(@real_path, new_path, false)
    end

    # Creates a symbolic link to the file.
    def link
      display_change
      begin
        File.symlink(@real_path, new_path)
      rescue NotImplemented
        puts "Error: cannot create symlinks"
      end
    end

    # Overriding the comparison operator to sort paths
    # based on their depth.
    def <=>(file_info)
      if (self.level == file_info.level)
      return (file_info.name <=> self.name)
      end
      file_info.level <=> self.level
    end
  end
end
