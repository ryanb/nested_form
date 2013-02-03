class Company < ActiveRecord::Base
  has_one :project
  accepts_nested_attributes_for :project

  after_initialize 'self.build_project'
end
