$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require "bundler/setup"
require "rails"
Bundler.require(:default)
require 'action_controller/railtie'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false

# a fake app for initializing the railtie
app = Class.new(Rails::Application)
app.config.secret_token = "token"
app.config.session_store :cookie_store, :key => "_myapp_session"
app.config.active_support.deprecation = :log
app.config.action_controller.perform_caching = false
app.initialize!

require 'rspec/rails'
RSpec.configure do |config|
  config.mock_with :mocha
end

ActiveRecord::Schema.define do
  create_table :projects, :force => true do |t|
    t.string :name
  end
end
class Project < ActiveRecord::Base
  # column :name, :string
  has_many :tasks
  accepts_nested_attributes_for :tasks
end

ActiveRecord::Schema.define do
  create_table :tasks, :force => true do |t|
    t.integer :project_id
    t.string :name
  end
end
class Task < ActiveRecord::Base
  # column :project_id, :integer
  # column :name, :string
  belongs_to :project
end

ActiveRecord::Schema.define do
  create_table :milestones, :force => true do |t|
    t.integer :task_id
    t.string :name
  end
end
class Milestone < ActiveRecord::Base
  # column :task_id, :integer
  # column :name, :string
  belongs_to :task
end
