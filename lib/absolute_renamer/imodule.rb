require 'absolute_renamer/with_children'

module AbsoluteRenamer
  # Modules parent class.
  # Modules must inherit of it.
  class IModule < AbsoluteRenamer::WithChildren
    def initialize
      @filters = []
    end

    # Returns the classname symbol
    def self.symbol
      name.intern
    end

    def self.process(file, name_format, ext_format)
      @mods ||= {}

      self.children.each do |mod|
        mod_sym = mod.symbol
        @mods[mod_sym] ||= mod.new
        name_format = @mods[mod_sym].process(file, name_format)
        ext_format = @mods[mod_sym].process(file, ext_format, :ext) unless file.dir
      end

      [name_format, ext_format]
    end

    # Returns a format pattern generated from pattern_string that
    # can be used to match strings like [*test] in the filename format
    #   pattern('test') #=> '(\[(.)?test\])'
    def pattern(pattern_string)
      Regexp.new "(\\[(.)?#{pattern_string}\\])"
    end

    # Returns a value modified using a modifier defined in the Case module
    #   modifiy('value', '&') #=> 'VALUE'
    #   modifiy('value', '*') #=> 'Value'
    def modify(val, modifier)
      modification = CaseModule.actions[modifier]
      val = CaseModule.send(modification, val) unless modification.nil?
      val
    end

    # Process a +file+ by searching for a known pattern in its name
    # and replacing it by the corresponding value.
    # The pattern is a regular expression obtained by concatening
    # the +@filters+ variable with "|".
    #
    # file: a FileInfo instance
    # format: the format string used to rename the file
    # type: the type of the renaming format (:name or :ext)
    def process(file, format, type = :name)
      return format if @filters.empty?

      result = []
      pattern = Regexp.union @filters
      idx = format.index(pattern)

      while idx
        matched = pattern.match(format).to_a
        part = format.partition(matched[0])
        result.push(part[0])
        result.push self.interpret(file, matched, type)
        format = part[2]
        idx = format.index(pattern)
      end
      result.push(format)
      format.replace(result.join)
    end

    # Interprets a matched pattern.
    # Searchs for the corresponding callback
    # in the current module and call it.
    #
    # file: a FileInfo instance
    # infos: the matched values depending of the pattern
    # type: the type of the renaming format (:name or :ext)
    def interpret(file, infos, type)
      # This method has to be overriden in every module
    end
  end
end
