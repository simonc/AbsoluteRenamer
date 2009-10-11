module AbsoluteRenamer
    class GeneralModule < AbsoluteRenamer::IModule
        def initialize
            @actions = {
                '*'  => :file_camelize,
                '$'  => :file_original,
                '%'  => :file_downcase,
                '&'  => :file_upcase,
                '\\' => :file_strip,
                '#'  => :count
            }

            @case_filters = [
                /\\\*/,     # \*
                /\\\$/,     # \$
                /\\%/,      # \%
                /\\&/,      # \&
                /\\\\/,     # \\
                /\*/,       # *
                /\$/,       # $
                /%/,        # %
                /&/,        # &
                /\\/        # \
            ]

            # matches strings like [42-43] [42-] [*42-43] [42;43] etc...
            @part_filters = [
                pattern('(\d+)((-(\d+)?)|(;\d+))?')
            ]

            # matches counters like # ### #{2} ##{2;42} or [length-42]
            @misc_filters = [
                /\//,
                /#+(\{.*\})?/,
                /\[length(--?\d+)?\]/
            ]

            @filters = @case_filters + @part_filters + @misc_filters
        end

        def interpret(file, infos, type)
            if (infos[0].length == 1)
                self.method(@actions[infos[0][0].chr]).call(file, infos, type)
            elsif (infos[0][1..6] == 'length')
                self.length(file, infos, type)
            elsif (infos[0][0].chr == '[')
                self.file_part(file, infos, type)
            elsif (infos[0][0].chr == '#')
                self.count(file, infos, type)
            else
                infos[0][1].chr
            end
        end

        def file_camelize(file, infos, type)
            file.send(type).camelize
        end

        def file_original(file, infos, type)
            file.send(type)
        end

        def file_downcase(file, infos, type)
            file.send(type).downcase
        end

        def file_upcase(file, infos, type)
            file.send(type).upcase
        end

        def file_strip(file, infos, type)
            file.send(type).strip
        end

        def file_part(file, infos, type)
            matched = infos[0].match(/(\[([^\d])?(\d+)(((;)(\d+))|((-)(\d+)?))?\])/)

            x = matched[3].to_i - 1
            y = matched[7] || matched[10]
            y = y.to_i unless y.nil?        
            action = matched[6] || matched[9]

            str = file.send(type)

            if (action == '-')
                y -= 1 unless y.nil?
                y ||= str.length
                val = str[x..y]
            elsif (action == ';')
                val = str[x, y]
            else
                val = str[x].chr
            end

            val ||= ''

            modify val, matched[2]
        end

        def count(file, infos, type)
            matched = infos[0].match(/(#+)(\{((-?\d+)(;(-?\d+)?)?)?\})?/)
            @counter ||= []
            @last ||= nil
            @current ||= 0

            @current = 0 if @last != file
            @current += 1 if @last == file

            start = matched[4] || 1
            step = matched[6] || 1
            start = start.to_i
            step = step.to_i

            @counter[@current] ||= {:start => start,
                                    :step => step,
                                    :current => start - step
                                   }

            @counter[@current][:current] += @counter[@current][:step]
            @last = file
            val = @counter[@current][:current].to_s.rjust(matched[1].length, '0')
            val.gsub!(/(0+)-/, '-\1')
            val
        end

        def length(file, infos, type)
            matched = infos[0].match(/\[length(-(-?\d+))?\]/)
            file.name.length - matched[2].to_i
        end
    end
end