class TasksController < ApplicationController
  def new
    @task = Task.new
  end
end
