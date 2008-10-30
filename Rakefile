require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'date'
 
test_files_pattern = 'test/**/*_test.rb'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = test_files_pattern
  t.verbose = false
end
 
desc "Run the test suite"
task :default => :test
 
spec = Gem::Specification.new do |s|
  s.name = "assert_performs"
  s.summary = "Easily add performance sanity checks using Test::Unit and a staging server"
  s.email = %w(jferris@thoughtbot.com dcroak@thoughtbot.com)
  s.homepage = "http://github.com/thoughtbot/assert_performs"
  s.description = "Easily add performance sanity checks using Test::Unit and a staging server"
  s.authors = ["Dan Croak", "Joe Ferris"]
  s.files = FileList["[A-Z]*", "{lib,test}/**/*"]
  s.version = '1.0.0'
end

Rake::GemPackageTask.new spec do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end
