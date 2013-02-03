class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end
end
