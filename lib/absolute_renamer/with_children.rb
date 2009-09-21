require 'absolute_renamer/use_config'

module AbsoluteRenamer
    # Class allowing childs listing.
    class WithChildren
        include AbsoluteRenamer::UseConfig

        @children = []
        class << self
            attr_reader :children

            # Inheritance callback.
            # When a class inherit from a WithChildren class, it is added to
            # the childs list of this class.
            # This list is available as the +children+ attribute.
            def inherited(by)
                @children << by
                by.instance_variable_set(:@children, [])
            end
        end
    end
end
