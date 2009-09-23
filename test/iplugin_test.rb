require 'test_helper'

class IPluginTest < Test::Unit::TestCase
  context "The IPlugin class" do

    should "be able to return its symbol" do
      assert_equal(:"AbsoluteRenamer::IPlugin", AbsoluteRenamer::IPlugin.symbol)
    end

  end
end
