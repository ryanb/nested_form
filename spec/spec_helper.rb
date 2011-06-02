$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require "bundler/setup"
Bundler.require(:default)

require "rails"
require "nested_form"

# a fake app for initializing the railtie
app = Class.new(Rails::Application)
app.config.secret_token = "token"
app.config.session_store :cookie_store, :key => "_myapp_session"
app.config.active_support.deprecation = :log
app.initialize!

require 'action_controller'
require 'active_record'
require 'rspec/rails'

RSpec.configure do |config|
  config.mock_with :mocha
end

$builders = [NestedForm::Builder, NestedForm::SimpleBuilder, NestedForm::FormtasticBuilder]

class TablelessModel < ActiveRecord::Base
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  def self.quoted_table_name
    name.pluralize.underscore
  end

  def quoted_id
    "0"
  end
end

class Project < TablelessModel
  column :name, :string
  has_many :tasks
  accepts_nested_attributes_for :tasks
end

class Task < TablelessModel
  column :project_id, :integer
  column :name, :string
  belongs_to :project
end

class Milestone < TablelessModel
  column :task_id, :integer
  column :name, :string
  belongs_to :task
end
