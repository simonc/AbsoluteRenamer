require 'test_helper'

class IModuleTest < Test::Unit::TestCase
  context "The IModule class" do

    should "be able to return its symbol" do
      assert_equal(:"AbsoluteRenamer::IModule", AbsoluteRenamer::IModule.symbol)
    end

  end

  context "An IModule instance" do

    setup do
      @imodule = AbsoluteRenamer::IModule.new
      @fileinfo = AbsoluteRenamer::FileInfo.new('/some/path/to/a_file.txt')
    end

    should "set the right filename format when calling process" do
      assert_equal('format', @imodule.process(@fileinfo, 'format', :name))
    end

    should "set the right extension format when calling process" do
      assert_equal('format', @imodule.process(@fileinfo, 'format', :ext))
    end

    context "with config file loaded" do

      setup do
        AbsoluteRenamer::Config.load('conf/absrenamer/absrenamer.conf')
        @default_string = AbsoluteRenamer::Config[:options][:default_string]
        @infos = [nil, nil, '', 'matched']
      end

      should "be able to interpret a matching result for filename" do
        assert_equal(@default_string, @imodule.interpret(@fileinfo, @infos, :name))
      end

      should "be able to interpret a matching result for extension" do
        assert_equal(@default_string, @imodule.interpret(@fileinfo, @infos, :ext))
      end

      should "be able to build a pattern from a pattern_string" do
        assert_equal(/(\[(.)?test\])/, @imodule.pattern('test'))
      end

      context "and core modules loaded" do

          setup do
            AbsoluteRenamer::External.load_core
          end

          should "be able to return a string transformed with a case modifier" do
            assert_equal("Hello World", @imodule.modify("heLLo wORLd", "*"))
          end

      end

    end
  end
end
