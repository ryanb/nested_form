# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'nested_form/version'

Gem::Specification.new do |s|
  s.name        = "nested_form"
  s.version     = NestedForm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Bates", "Andrea Singh"]
  s.email       = ["info@madebydna.com"]
  s.homepage    = "http://github.com/madebydna/nested_form"
  s.summary     = "Gem to conveniently handle multiple models in a single form."
  s.description = "Gem to conveniently handle multiple models in a single form. Rails 2 plugin by Ryan Bates converted into a gem."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "nested_form"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.5"
  s.add_development_dependency "rspec", "~> 2.0.0.beta.22"
  s.add_development_dependency "rr"
  s.add_development_dependency "rails", "~> 3.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end