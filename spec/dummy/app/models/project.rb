class Project < ActiveRecord::Base
  has_many :tasks
  accepts_nested_attributes_for :tasks
end
