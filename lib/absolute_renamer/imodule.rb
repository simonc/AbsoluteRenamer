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
            unless modifier.nil?
                mod = CaseModule.method(CaseModule.actions[modifier])
                val = mod.call(val)
            end
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

            str = format
            result = []
            pattern = Regexp.union @filters

            idx = str.index(pattern)
            while idx
                matched = pattern.match(str).to_a
                part = str.partition(matched[0])
                result.push(part[0])
                val = self.interpret(file, matched, type)
                result.push(val)
                str = part[2]
                idx = str.index(pattern)
            end
            result.push(str) unless str.empty?
            format.replace(result.join)
            format
        end

        # Interprets a matched pattern.
        # Searchs for the corresponding callback
        # in the current module and call it.
        #
        # file: a FileInfo instance
        # infos: the matched values depending of the pattern
        # type: the type of the renaming format (:name or :ext)
        def interpret(file, infos, type)
            modifier = infos[2]
            action = infos[3]

            return conf[:options][:default_string] unless self.respond_to?(action.intern)

            ap = self.method(action.intern)
            val = ap.call(file, infos, type)
            unless modifier.empty?
                mp = CaseModule.method(CaseModule.actions[modifier])
                val = mp.call(val)
            end
            val.empty? ? conf[:options][:default_string] : val
        end
    end
end
