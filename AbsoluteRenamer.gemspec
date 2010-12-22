# -*- encoding: utf-8 -*-
require File.expand_path("../lib/absolute_renamer/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "AbsoluteRenamer"
  s.version     = AbsoluteRenamer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon COURTOIS"]
  s.email       = ["happynoff@free.fr"]
  s.homepage    = "http://github.com/simonc/AbsoluteRenamer"
  s.summary     = "AbsoluteRenamer is a very powerful tool that helps files "  \
                  "and directories renaming using the Krename syntax."
  s.description = "AbsoluteRenamer is a very powerful tool that helps files "  \
                  "and directories renaming using the Krename syntax. Unlike " \
                  "many batch renaming tools, AbsoluteRenamer is able to "     \
                  "rename folders. AbsoluteRenamer is modular and can be "     \
                  "extended to adapt itself to any kind of file or to add "    \
                  "new options and features."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "absrenamer"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "thoughtbot-shoulda", ">= 0"

  s.files            = `git ls-files`.split("\n")
  s.executables      = `git ls-files`.split("\n").map {|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path     = 'lib'
  s.test_files       = `git ls-files`.split("\n").map{|f| f =~ /^test\/.*/ ? f : nil}.compact
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]

  s.rdoc_options = ["--charset=UTF-8"]
end
