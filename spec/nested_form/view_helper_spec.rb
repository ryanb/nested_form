require "spec_helper"

describe NestedForm::ViewHelper do
  before(:each) do
    @template = ActionView::Base.new
    @template.output_buffer = ""
    @template.stubs(:url_for).returns("")
    @template.stubs(:projects_path).returns("")
    @template.stubs(:protect_against_forgery?).returns(false)
  end

  it "should pass nested form builder to form_for along with other options" do
    pending
    mock.proxy(@template).form_for(:first, :as => :second, :other => :arg, :builder => NestedForm::Builder) do |form_html|
      form_html
    end
    @template.nested_form_for(:first, :as => :second, :other => :arg) {"form"}
  end

  it "should pass instance of NestedForm::Builder to nested_form_for block" do
    @template.nested_form_for(Project.new) do |f|
      f.should be_instance_of(NestedForm::Builder)
    end
  end

  it "should pass instance of NestedForm::SimpleBuilder to simple_nested_form_for block" do
    @template.simple_nested_form_for(Project.new) do |f|
      f.should be_instance_of(NestedForm::SimpleBuilder)
    end
  end

  it "should pass instance of NestedForm::FormtasticBuilder to semantic_nested_form_for block" do
    @template.semantic_nested_form_for(Project.new) do |f|
      f.should be_instance_of(NestedForm::FormtasticBuilder)
    end
  end

  it "should append content to end of nested form" do
    @template.after_nested_form(:tasks) { @template.concat("123") }
    @template.after_nested_form(:milestones) { @template.concat("456") }
    @template.nested_form_for(Project.new) {}
    @template.output_buffer.should include("123456")
  end
end

