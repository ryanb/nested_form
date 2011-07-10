require 'rubygems'
# require 'appraisal'
require 'rake'
require 'rspec/core/rake_task'

desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
end

task :default => :spec
namespace :spec do
  task :install do
    puts `bundle install --gemfile=gemfiles/Gemfile.rails3_0`
    puts `bundle install --gemfile=gemfiles/Gemfile.rails3_1`
  end
  
  task :all do
    ENV['BUNDLE_GEMFILE'] = File.expand_path('../gemfiles/Gemfile.rails3_0', __FILE__)
    Rake::Task["spec"].execute
    
    ENV['BUNDLE_GEMFILE'] = File.expand_path('../gemfiles/Gemfile.rails3_1', __FILE__)
    Rake::Task["spec"].execute
  end
end