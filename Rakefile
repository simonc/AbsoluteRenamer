require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "AbsoluteRenamer"
    gem.summary = %Q{AbsoluteRenamer is a very powerful tool that helps files and directories renaming using the Krename syntax.}
    gem.description = %Q{Unlike many batch renaming tools, AbsoluteRenamer is able to rename folders.
                         AbsoluteRenamer is modular and can be extended to adapt itself to any kind of file
                         or to add new options and features.}
    gem.email = "happynoff@free.fr"
    gem.homepage = "http://github.com/simonc/AbsoluteRenamer"
    gem.authors = ["Simon COURTOIS"]
    gem.add_development_dependency "thoughtbot-shoulda"
    gem.rubyforge_project = "absrenamer"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "AbsoluteRenamer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
