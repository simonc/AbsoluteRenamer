require 'test_helper'

class LibStringTest < Test::Unit::TestCase
  context "A String instance" do

    should "return Hello World when camelizing hello world" do
      assert_equal("Hello World", "hello world".camelize)
    end

    should "return Hello.World when camelizing hello.world" do
      assert_equal("Hello.World", "hello.world".camelize)
    end

    should "return Hello The.World when camelizing hello THE.world" do
      assert_equal("Hello The.World", "hello THE.world".camelize)
    end

    should "return Hello..World when camelizing hello..world" do
      assert_equal("Hello..World", "hello..world".camelize)
    end

    should "return Hello.World when camelizing hello.world with the /\./ separation pattern" do
      assert_equal("Hello.World", "hello.world".camelize(/\./))
    end

    should "return Hello The.world when camelizing hello THE.world with the / / separation pattern" do
      assert_equal("Hello The.world", "hello THE.world".camelize(/ /))
    end

    context "set to hello world" do

      setup do
        @string = 'hello world'
      end

      should "return and be equal to Hello World when calling camelize!" do
        assert_equal("Hello World", @string.camelize!)
        assert_equal("Hello World", @string)
      end

    end

  end
end
