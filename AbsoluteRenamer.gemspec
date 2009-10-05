# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{AbsoluteRenamer}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simon COURTOIS"]
  s.date = %q{2009-10-05}
  s.default_executable = %q{absrenamer}
  s.description = %q{AbsoluteRenamer is a very powerful tool that helps files and directories renaming using the Krename syntax. Unlike many batch renaming tools, AbsoluteRenamer is able to rename folders. AbsoluteRenamer is modular and can be extended to adapt itself to any kind of file or to add new options and features.}
  s.email = %q{happynoff@free.fr}
  s.executables = ["absrenamer"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "AbsoluteRenamer.gemspec",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/absrenamer",
     "conf/absrenamer/absrenamer.conf",
     "lib/absolute_renamer.rb",
     "lib/absolute_renamer/config.rb",
     "lib/absolute_renamer/core-packages/core-case/module.rb",
     "lib/absolute_renamer/core-packages/core-general/module.rb",
     "lib/absolute_renamer/core-packages/core-general/parser.rb",
     "lib/absolute_renamer/core-packages/core-interactive/parser.rb",
     "lib/absolute_renamer/core-packages/core-interactive/plugin.rb",
     "lib/absolute_renamer/core-packages/core-listing/parser.rb",
     "lib/absolute_renamer/core-packages/core-listing/plugin.rb",
     "lib/absolute_renamer/core-packages/core-packages.rb",
     "lib/absolute_renamer/external.rb",
     "lib/absolute_renamer/file_info.rb",
     "lib/absolute_renamer/imodule.rb",
     "lib/absolute_renamer/iparser.rb",
     "lib/absolute_renamer/iplugin.rb",
     "lib/absolute_renamer/libs/file.rb",
     "lib/absolute_renamer/libs/hash.rb",
     "lib/absolute_renamer/libs/string.rb",
     "lib/absolute_renamer/parser.rb",
     "lib/absolute_renamer/use_config.rb",
     "lib/absolute_renamer/with_children.rb",
     "test/absolute_renamer_test.rb",
     "test/config_test.rb",
     "test/file_info_test.rb",
     "test/file_test.rb",
     "test/hash_test.rb",
     "test/imodule_test.rb",
     "test/iplugin_test.rb",
     "test/parser_test.rb",
     "test/string_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/simonc/AbsoluteRenamer}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{absrenamer}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{AbsoluteRenamer is a very powerful tool that helps files and directories renaming using the Krename syntax.}
  s.test_files = [
    "test/string_test.rb",
     "test/file_test.rb",
     "test/iplugin_test.rb",
     "test/absolute_renamer_test.rb",
     "test/test_helper.rb",
     "test/config_test.rb",
     "test/hash_test.rb",
     "test/imodule_test.rb",
     "test/parser_test.rb",
     "test/file_info_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end
