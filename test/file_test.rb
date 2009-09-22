require 'test_helper'

# Called LibFileTest instead of FileTest to avoid ruby errors
class LibFileTest < Test::Unit::TestCase
  context "The File class" do

    should "return txt for a_file.txt when calling extname" do
      assert_equal("txt", File.extname('a_file.txt'))
    end
    
    should "return an empty string for a_file when calling extname" do
      assert_equal("", File.extname('a_file'))
    end

    should "return tar.gz for archive.tar.gz when calling extname with 2 dots" do
      assert_equal("tar.gz", File.extname('archive.tar.gz', 2))
    end
    
    should "return gz for archive.tar.gz when calling extname" do
      assert_equal("gz", File.extname('archive.tar.gz'))
    end

    should "return an empty string for . and a_file. when calling extname" do
      assert_equal("", File.extname('.'))
      assert_equal("", File.extname('fichier.'))
    end

    should "return test for .test when calling extname" do
      assert_equal("test", File.extname('.test'))
    end

  end
end
