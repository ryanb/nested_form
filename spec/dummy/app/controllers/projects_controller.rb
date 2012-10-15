class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end
  def create
    @project = Project.new params[:project]
    if @project.save
      redirect_to projects_path
    else
      render :action => :new
    end    
  end
    
  def edit
    @project = Project.find params[:id]
  end
  def update
    @project = Project.find params[:id]
    if @project.update_attributes params[:project]
      redirect_to projects_path
    else
      render :action => :edit
    end
  end
  
  def index
    @projects = Project.all
  end
end
