require 'test_helper'

class ParserTest < Test::Unit::TestCase
  context "A Parser instance" do

    context "with config file and core-externals loaded and the -f'format' option set" do

      setup do
        AbsoluteRenamer::External.load_core

        AbsoluteRenamer::Config.load('conf/absrenamer/absrenamer.conf')
        ARGV << '-f'
        ARGV << 'format'
      end

      should "be able to parse the format from the command line options" do
        AbsoluteRenamer::Parser.parse_cmd_line
        assert_equal('format', AbsoluteRenamer::Config[:options][:format])
      end

    end
  end
end
