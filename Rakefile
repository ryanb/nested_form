require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

task :spec do
  `rm Gemfile` if File.exists?('./Gemfile')
  `cp Gemfile-base Gemfile`
  `bundle install`
end

task :simple_form_spec do
  `rm Gemfile` if File.exists?('./Gemfile')
  `cp Gemfile-simple_form Gemfile`
  `bundle install`
end

desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
end

desc "Run RSpec for SimpleForm Gemfile"
RSpec::Core::RakeTask.new(:simple_form_spec) do |t|
  t.verbose = false
end

task :default => [:spec, :simple_form_spec]
