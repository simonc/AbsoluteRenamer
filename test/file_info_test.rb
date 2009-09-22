require 'test_helper'

class FileInfoTest < Test::Unit::TestCase
  context "A FileInfo instance" do
    context "loaded with some/path/to/a_file.txt" do

      setup do
        @pwd = Dir.pwd
        @fileinfo = AbsoluteRenamer::FileInfo.new('some/path/to/a_file.txt')
      end

      should "have as name : a_file" do
        assert_equal('a_file', @fileinfo.name)
      end

      should "have as dir_path : pwd/some/path/to" do
        assert_equal(@pwd + '/some/path/to', @fileinfo.dir_path)
      end

      should "have as path : some/path/to/a_file.txt" do
        assert_equal('some/path/to/a_file.txt', @fileinfo.path)
      end

      should "have as real_path : pwd/some/path/to/a_file.txt" do
        assert_equal(@pwd + '/some/path/to/a_file.txt', @fileinfo.real_path)
      end

      should "have as ext : txt" do
        assert_equal('txt', @fileinfo.ext)
      end

      should "have as dir : false" do
        assert_equal(false, @fileinfo.dir)
      end

    end

    context "loaded with lib/absolute_renamer" do

      setup do
        @pwd = Dir.pwd
        @fileinfo = AbsoluteRenamer::FileInfo.new('lib/absolute_renamer')
      end

      should "have as name : absolute_renamer" do
        assert_equal('absolute_renamer', @fileinfo.name)
      end

      should "have as dir_path : pwd/lib" do
        assert_equal(@pwd + '/lib', @fileinfo.dir_path)
      end

      should "have as path : lib/absolute_renamer" do
        assert_equal('lib/absolute_renamer', @fileinfo.path)
      end

      should "have as real_path : pwd/lib/absolute_renamer" do
        assert_equal(@pwd + '/lib/absolute_renamer', @fileinfo.real_path)
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
