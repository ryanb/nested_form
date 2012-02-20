require 'rubygems'

gemfile = ENV['BUNDLE_GEMFILE'] || File.expand_path('../../../../gemfiles/Gemfile.rails3_1', __FILE__)
if File.exist?(gemfile)
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
end

$:.unshift File.expand_path('../../../../lib', __FILE__)