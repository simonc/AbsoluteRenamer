module AbsoluteRenamer
    class InteractivePlugin < AbsoluteRenamer::IPlugin
        def before_batch_renaming
            if conf[:options][:interactive] == :once
                conf[:files].each do |file|
                    file.display_change
                end
                print "Do you want to rename this files ? [y/N] "
                begin
                    resp = STDIN.readline.chomp.downcase
                rescue Exception => e
                    puts "\nExiting renamer"
                    exit(0)
                end
                return resp == "y"
            end
            true
        end

        def before_file_renaming(params)
            if conf[:options][:interactive] == :always
                params[:file].display_change
                print "Do you want to rename this file ? [y/N] "
                begin
                    resp = STDIN.readline.chomp.downcase
                rescue Exception => e
                    puts "\nExiting renamer"
                    exit(0)
                end
                return resp == "y"
            end
            true
        end
    end
end
