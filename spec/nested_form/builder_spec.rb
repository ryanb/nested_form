require "spec_helper"

[NestedForm::Builder, NestedForm::SimpleBuilder, defined?(NestedForm::FormtasticBuilder) ? NestedForm::FormtasticBuilder : nil].compact.each do |builder|
  describe builder do
    describe "with no options" do
      before(:each) do
        @project = Project.new
        @template = ActionView::Base.new
        @template.output_buffer = ""
        @builder = builder.new(:item, @project, @template, {}, proc {})
      end

      it "has an add link which behaves similar to a Rails link_to" do
        @builder.link_to_add("Add", :tasks).should == '<a href="javascript:void(0)" class="add_nested_fields" data-association="tasks">Add</a>'
        @builder.link_to_add("Add", :tasks, :class => "foo", :href => "url").should == '<a href="url" class="foo add_nested_fields" data-association="tasks">Add</a>'
        @builder.link_to_add(:tasks) { "Add" }.should == '<a href="javascript:void(0)" class="add_nested_fields" data-association="tasks">Add</a>'
      end

      it "has a remove link which behaves similar to a Rails link_to" do
        @builder.link_to_remove("Remove").should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="false" /><a href="javascript:void(0)" class="remove_nested_fields">Remove</a>'
        @builder.link_to_remove("Remove", :class => "foo", :href => "url").should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="false" /><a href="url" class="foo remove_nested_fields">Remove</a>'
        @builder.link_to_remove { "Remove" }.should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="false" /><a href="javascript:void(0)" class="remove_nested_fields">Remove</a>'
      end

      it "should wrap nested fields each in a div with class" do
        2.times { @project.tasks.build }
        @builder.fields_for(:tasks) do
          "Task"
        end.should == '<div class="fields">Task</div><div class="fields">Task</div>'
      end

      it "should add task fields to hidden div after form" do
        pending
        output = ""
        mock(@template).after_nested_form(:tasks) { |arg, block| output << block.call }
        @builder.fields_for(:tasks) { "Task" }
        @builder.link_to_add("Add", :tasks)
        output.should == '<div id="tasks_fields_blueprint" style="display: none"><div class="fields">Task</div></div>'
      end
    end
  end
end
