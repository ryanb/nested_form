require File.dirname(__FILE__) + '/../spec_helper'

describe NestedForm::ViewHelper do
  before(:each) do
    @template = ActionView::Base.new
    @template.output_buffer = ""
    stub(@template).url_for { "" }
    stub(@template).protect_against_forgery? { false }
  end
  
  it "should pass nested form builder to form_for along with other options" do
    mock(@template).form_for(:first, :second, :other => :arg, :builder => NestedForm::Builder)
    @template.nested_form_for(:first, :second, :other => :arg)
  end
  
  it "should pass instance of NestedForm::Builder to nested_form_for block" do
    @template.nested_form_for(:project, Project) do |f|
      f.should be_instance_of(NestedForm::Builder)
    end
  end
  
  it "should append content to end of nested form" do
    @template.after_nested_form { @template.concat("123") }
    @template.after_nested_form { @template.concat("456") }
    @template.nested_form_for(:project, Project) {}
    @template.output_buffer.should include("123456")
  end
end
