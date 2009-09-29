require 'test_helper'

class LibHashTest < Test::Unit::TestCase
  context "A Hash instance" do

    setup do
      @hash1 = { :key1 => :val1, :key2 => { :key21 => :val21 } }
      @hash2 = { :key2 => { :key22 => :val22 }, :key3 => :val3 }
      @hash3 = { :key1 => :val12 }

      @result1 = { :key1 => :val1, :key2 => { :key21 => :val21, :key22 => :val22 }, :key3 => :val3 }
      @result2 = { :key1 => :val12, :key2 => { :key21 => :val21 } }
    end

    should "be able to merge recursively with another without changing" do
      assert_equal @hash1.deep_merge(@hash2), @result1
      assert_not_equal @hash1, @result
    end

    should "be able to merge recursively with another" do
      @hash1.deep_merge! @hash2
      assert_equal @hash1, @result1
    end

    should "be able to simply merge with another" do
      @hash1.deep_merge! @hash3
      assert_equal @hash1, @result2
    end
  end
end
