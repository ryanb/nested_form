require 'rubygems'
require 'spec'
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_view'
require File.dirname(__FILE__) + '/../lib/nested_form.rb'

Spec::Runner.configure do |config|
  config.mock_with :rr
end
