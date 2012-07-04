class Task < ActiveRecord::Base
  belongs_to :project
  has_many :milestones
  accepts_nested_attributes_for :milestones
end
