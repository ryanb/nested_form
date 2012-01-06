class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end
end
