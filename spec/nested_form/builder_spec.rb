require File.dirname(__FILE__) + '/../spec_helper'

describe NestedForm::Builder do
  describe "with no options" do
    before(:each) do
      @project = Project.new
      @template = ActionView::Base.new
      @template.output_buffer = ""
      @builder = NestedForm::Builder.new(:item, @project, @template, {}, proc {})
    end
  
    it "should have an add link" do
      @builder.link_to_add("Add", :tasks).should == '<a href="javascript:void(0)" class="add_nested_fields" data-association="tasks">Add</a>'
    end
  
    it "should have a remove link" do
      @builder.link_to_remove("Remove").should == '<input id="item__destroy" name="item[_destroy]" type="hidden" /><a href="javascript:void(0)" class="remove_nested_fields">Remove</a>'
    end
    
    it "should wrap nested fields each in a div with class" do
      2.times { @project.tasks.build }
      @builder.fields_for(:tasks) do
        @template.concat("Task")
      end
      @template.output_buffer.should == '<div class="fields">Task</div><div class="fields">Task</div>'
    end
    
    it "should add task fields to hidden div after form" do
      mock(@template).after_nested_form { |block| block.call }
      @builder.fields_for(:tasks) { @template.concat("Task") }
      @builder.link_to_add("Add", :tasks)
      @template.output_buffer.should == '<div id="tasks_fields_blueprint" style="display: none"><div class="fields">Task</div></div>'
    end
  end
end
