module AbsoluteRenamer
    class CaseModule < AbsoluteRenamer::IModule
        class << self
            attr_reader :actions
        
            def actions
                @actions ||= {'*' => :camelize,
                              '&' => :upper,
                              '%' => :lower,
                              '$' => :original
                             }
            end

            def camelize(str)
                str.camelize
            end

            def original(str)
                str
            end

            def lower(str)
                str.downcase
            end

            def upper(str)
                str.upcase
            end
        end
    end
end