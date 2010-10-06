module AbsoluteRenamer
  class InteractivePlugin < AbsoluteRenamer::IPlugin
    def before_batch_renaming
      ask_for_confirmation(:once, 'Do you want to rename this files ?') do
        conf[:files].each do |file|
          file.display_change
        end
      end
    end

    def before_file_renaming(params)
      ask_for_confirmation(:always, 'Do you want to rename this file ?') do
        params[:file].display_change
      end
    end

    def ask_for_confirmation(interactivity, message, waited_answer = 'y')
      if conf[:options][:interactive] == interactivity
        yield

        print "#{message} [y/N] "

        begin
          resp = STDIN.readline.chomp.downcase
        rescue
          puts "\nExiting renamer"
          exit(0)
        end

        return resp == waited_answer
      end
      true
    end
  end
end
