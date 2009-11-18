module AbsoluteRenamer
  class ListingPlugin < AbsoluteRenamer::IPlugin
    def before_batch_renaming
      listing = conf[:options][:listing] || false
      if listing
        conf[:files].each do |file|
          file.display_change
        end
        return false
      end
      true
    end
  end
end
