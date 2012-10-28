class Project < ActiveRecord::Base
  has_many :tasks
  has_many :assignments, :class_name => 'ProjectTask' 
  accepts_nested_attributes_for :tasks
  accepts_nested_attributes_for :assignments

  has_many :not_nested_tasks, :class_name => 'Task'
end
