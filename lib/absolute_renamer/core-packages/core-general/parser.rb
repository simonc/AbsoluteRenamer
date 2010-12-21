# TODO ajouter une option pour la gestion du nombre de points avant l'extension
module AbsoluteRenamer
  class GeneralParser < AbsoluteRenamer::IParser
    def self.add_options(parser, options)
      parser.banner << ' [file]...'
      parser.on_tail('-h', '--help', 'Display this help screen') do
        puts parser
        exit 0
      end

      parser.on('-r', '--replace PATTERN,REPLACEMENT', Array,
                'String replacement ex:"pattern,replacement" ') do |data|
        self.add_replacement(data, options)
      end

      parser.on('-e', '--regexp-replace PATTERN,REPLACEMENT', Array,
                'String replacement using regexp') do |data|
        self.add_replacement(data, options, true)
      end

      parser.on('-f', '--format FORMAT',
                'Format string used as model') do |format|
        options[:format] = format
        @format_given = true

        raise "Format cannot contain the / character." if format.match(/\//)
      end

      parser.on('-x', '--ext-format FORMAT',
                'Format string used as model for the extension') do |format|
        options[:ext_format] = format

        raise "Format cannot contain the / character." if format.match(/\//)
      end

      parser.on('--no-ext', '--no-extension', 'Removes the extension') do
        options[:rm_ext] = true
      end

      parser.on('-R', '--recursive',
                'Rename files in subdirectories recursively') do
        options[:rec] = true
      end

      parser.on('--maxdepth N', Integer, 'Maximum recursion depth') do |depth|
        options[:maxdepth] = depth
      end

      parser.on('-m', '--mode MODE', [:rename, :copy, :move, :link],
                'Renaming mode. Can be used with --dest DEST.',
                '  rename: simply rename files',
                '  copy: make a copy of each file in DEST with its new name',
                '  move: move each file in DEST with its new name',
                '  link: create a symbolic link to each file in DEST' <<
                ' with its new name') do |mode|
        options[:mode] = mode
      end

      parser.on('--dest DEST', 'Destination directory' <<
                ' for copy, move and link modes') do |dest|
        options[:dest] = File.expand_path(dest)
      end
      
      parser.on('-d', '--directories', 'Directories handling') do
        options[:dir] = true
      end
    end

    def self.add_replacement(data, options, regexp = false)
      pattern, replace = data[0..1]
      replace ||= ''
      pattern = Regexp.new(pattern) if regexp
      moment = @format_given.nil? ? :before : :after
      options[:replacements] ||= {
        :before => [],
        :after  => []
      }
      options[:replacements][moment] << {
        :type  => pattern.class,
        :pattern => pattern,
        :replace => replace
      }
    end
  end
end
