module AbsoluteRenamer
    class InteractiveParser < AbsoluteRenamer::IParser
        def self.add_options(parser, options)
            parser.on('-i', 'Prompt before each renamming') do
                options[:interactive] = :always
            end

            parser.on('-I', 'Prompt once before batch renamming') do
                options[:interactive] = :once
            end

            parser.on('--interactive [WHEN]', [:always, :never, :once],
                      'Prompt according to WHEN: never, once (-I), or always (-i).',
                      'Without WHEN, prompt always') do |w|
                w = :always if w.nil?
                options[:interactive] = w
            end
        end
    end
end
