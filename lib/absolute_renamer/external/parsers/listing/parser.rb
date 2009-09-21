module AbsoluteRenamer
    class ListingParser < AbsoluteRenamer::IParser
        def self.add_options(parser, options)
            parser.on('-l', '--list', "Only display how files will be renamed") do
                options[:listing] = true
            end
        end
    end
end
