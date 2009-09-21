require 'absolute_renamer/config'

module AbsoluteRenamer
    # Module that provide configuration usage.
    module UseConfig
        # Returns the configuration class
        def conf
            @conf ||= AbsoluteRenamer::Config
        end
    end
end