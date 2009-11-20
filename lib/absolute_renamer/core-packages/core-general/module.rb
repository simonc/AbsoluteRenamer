module AbsoluteRenamer
  class GeneralModule < AbsoluteRenamer::IModule
    def initialize
      @case_filters = [
        /\\\*/,   # \*
        /\\\$/,   # \$
        /\\%/,    # \%
        /\\&/,    # \&
        /\\\\/,   # \\
        /\*/,     # *
        /\$/,     # $
        /%/,    # %
        /&/,    # &
        /\\/    # \
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
      if (infos[0][0].chr == '#')
        count(file, infos)
      elsif (infos[0].length == 1)
        file_case(file, infos[0], type)
      elsif (infos[0][1..6] == 'length')
        length(file, infos)
      elsif (infos[0][0].chr == '[')
        file_part(file, infos, type)
      else
        infos[0][1].chr
      end
    end

    def file_case(file, modifier, type)
      file_info = file.send(type)

      if modifier.match /\\/
        file_info.strip!
      else
        file_info = modify(file_info, modifier)
      end

      file_info
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

    def count(file, infos)
      matched = infos[0].match(/(#+)(\{((-?\d+)(;(-?\d+)?)?)?\})?/)
      @counter ||= []
      @last  ||= nil

      @current = (@last != file) ? 0 : @current + 1

      @counter[@current] ||= {
        :value   => (matched[4] || 1).to_i,
        :step  => (matched[6] || 1).to_i,
      }

      val = @counter[@current][:value].to_s.rjust(matched[1].length, '0')
      val.gsub!(/(0+)-/, '-\1')

      @counter[@current][:value] += @counter[@current][:step]
      @last = file

      val
    end

    def length(file, infos)
      matched = infos[0].match(/\[length(-(-?\d+))?\]/)
      file.name.length - matched[2].to_i
    end
  end
end