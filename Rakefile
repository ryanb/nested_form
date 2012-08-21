require 'rubygems'
require 'rake'

begin
  require 'rspec/core/rake_task'
  desc "Run RSpec"
  RSpec::Core::RakeTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  puts "You should run rake spec:install in order to install all corresponding gems!"
end

task :default => :spec

namespace :db do
  desc 'Prepare sqlite database'
  task :migrate do
    system 'cd spec/dummy && rake db:migrate RAILS_ENV=test && rake db:migrate RAILS_ENV=development'
  end
end

namespace :spec do
  desc 'Install gems from additional gemfiles'
  task :install do
    system 'bundle install'
    ENV.delete('GEM_HOME')
    ENV['BUNDLE_GEMFILE'] = File.expand_path('../gemfiles/Gemfile.rails3_1', __FILE__)
    system 'bundle install'
    ENV['BUNDLE_GEMFILE'] = File.expand_path('../gemfiles/Gemfile.rails3_0', __FILE__)
    system 'bundle install'
  end

  desc 'Run tests with Rails 3.1.x'
  task :rails3_1 do
    ENV.delete('GEM_HOME')
    ENV['BUNDLE_GEMFILE'] = File.expand_path('../gemfiles/Gemfile.rails3_1', __FILE__)
    Rake::Task["spec"].execute
  end

  desc 'Run tests with Rails 3.0.x'
  task :rails3_0 do
    ENV.delete('GEM_HOME')
    ENV['BUNDLE_GEMFILE'] = File.expand_path('../gemfiles/Gemfile.rails3_0', __FILE__)
    Rake::Task["spec"].execute
  end

  task :all do
    Rake::Task["spec"].execute
    Rake::Task["spec:rails3_1"].execute
    Rake::Task["spec:rails3_0"].execute
  end
end
