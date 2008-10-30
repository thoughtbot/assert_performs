Gem::Specification.new do |s|
  s.name = %q{assert_performs}
  s.version = "1.0.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Croak", "Joe Ferris"]
  s.date = %q{2008-10-30}
  s.description = %q{Easily add performance sanity checks using Test::Unit and a staging server}
  s.email = ["jferris@thoughtbot.com", "dcroak@thoughtbot.com"]
  s.files = ["Rakefile", "lib/assert_performs.rb", "test/assert_performs_test.rb", "test/httperf_output.erb"]
  s.homepage = %q{http://github.com/thoughtbot/assert_performs}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{Easily add performance sanity checks using Test::Unit and a staging server}
end
