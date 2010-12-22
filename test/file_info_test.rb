require 'test_helper'

class FileInfoTest < Test::Unit::TestCase
  context "A FileInfo instance" do
    context "loaded with /tmp/test-absrenamer.txt" do

      setup do
        AbsoluteRenamer::Config.load('conf/absrenamer/absrenamer.conf')
        `touch /tmp/test-absrenamer.txt`
        @fileinfo = AbsoluteRenamer::FileInfo.new('/tmp/test-absrenamer.txt')
      end

      should "have as name : test-absrenamer" do
        assert_equal('test-absrenamer', @fileinfo.name)
      end

      should "have as dir_path : /tmp" do
        assert_equal('/tmp', @fileinfo.dir_path)
      end

      should "have as path : /tmp/test-absrenamer.txt" do
        assert_equal('/tmp/test-absrenamer.txt', @fileinfo.path)
      end

      should "have as real_path : /tmp/test-absrenamer.txt" do
        assert_equal('/tmp/test-absrenamer.txt', @fileinfo.real_path)
      end

      should "have as ext : txt" do
        assert_equal('txt', @fileinfo.ext)
      end

      should "have as dir : false" do
        assert_equal(false, @fileinfo.dir)
      end

      should "be able to return a colorized string" do
          assert_equal("\e[31mhello\e[0m", @fileinfo.color('hello'))
      end

    end

    context "loaded with /usr/bin" do

      setup do
        AbsoluteRenamer::Config.load('conf/absrenamer/absrenamer.conf')
        @fileinfo = AbsoluteRenamer::FileInfo.new('/usr/bin')
      end

      should "have as name : bin" do
        assert_equal('bin', @fileinfo.name)
      end

      should "have as dir_path : /usr" do
        assert_equal('/usr', @fileinfo.dir_path)
      end

      should "have as path : usr/bin" do
        assert_equal('/usr/bin', @fileinfo.path)
      end

      should "have as real_path : /usr/bin" do
        assert_equal('/usr/bin', @fileinfo.real_path)
      end

      should "have as ext : nil" do
        assert_nil @fileinfo.ext
      end

      should "have as dir : true" do
        assert_equal(true, @fileinfo.dir)
      end

    end
  end
end
