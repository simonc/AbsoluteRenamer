require 'absolute_renamer/with_children'

module AbsoluteRenamer
    # Plugins parent class.
    # Plugins must inherit of it.
    class IPlugin < AbsoluteRenamer::WithChildren
        def self.symbol
            name.intern
        end
    end
end
