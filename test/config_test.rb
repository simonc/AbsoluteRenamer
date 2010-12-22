require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  context "The Config instance" do

    should "exist" do
      assert_not_nil AbsoluteRenamer::Config
    end

    should "not raise ENOENT if config file is found" do
      assert_nothing_raised(Errno::ENOENT) do
        AbsoluteRenamer::Config.load('conf/absrenamer/absrenamer.conf')
      end
    end

    context "with a loaded config file" do
      setup do
        AbsoluteRenamer::Config.load('conf/absrenamer/absrenamer.conf')
      end

      should "be able to set and get config options" do
        AbsoluteRenamer::Config.set(:test_key, :test_val)
        assert_equal(:test_val, AbsoluteRenamer::Config.get(:test_key))
      end

      should "return the whole configuration if the getting key is nil" do
        AbsoluteRenamer::Config.set(nil, :test_val)
        assert_equal(AbsoluteRenamer::Config.get, AbsoluteRenamer::Config.get(nil))
      end

      should "be able to set config options using []" do
        AbsoluteRenamer::Config[:test_key] = :test_val
        assert_equal(:test_val, AbsoluteRenamer::Config[:test_key])
      end
    end

  end
end
