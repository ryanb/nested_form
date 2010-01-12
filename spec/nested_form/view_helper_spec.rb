require File.dirname(__FILE__) + '/../spec_helper'

describe NestedForm::ViewHelper do
  before(:each) do
    @helper = ActionView::Base.new
    @helper.output_buffer = ""
    stub(@helper).url_for { "" }
    stub(@helper).protect_against_forgery? { false }
  end
  
  it "should pass nested form builder to form_for along with other options" do
    mock(@helper).form_for(:first, :second, :other => :arg, :builder => NestedForm::Builder)
    @helper.nested_form_for(:first, :second, :other => :arg)
  end
  
  it "should pass instance of NestedForm::Builder to nested_form_for block" do
    @helper.nested_form_for(:project, Project) do |f|
      f.should be_instance_of(NestedForm::Builder)
    end
  end
  
  it "should append content to end of nested form" do
    @helper.after_nested_form { "after_nested_form" }
    @helper.nested_form_for(:project, Project) {}.should include("after_nested_form")
  end
end
