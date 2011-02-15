require 'active_model'
require 'active_record'
require 'action_controller'
require 'action_view'
require 'action_view/template'

require 'nested_form/view_helper'
require 'nested_form/builder'

Rspec.configure do |config|
  config.mock_with :rr
end

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
