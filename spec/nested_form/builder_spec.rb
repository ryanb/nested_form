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
          "<p>Task</p>".html_safe
        end.should == '<div class="fields"><p>Task</p></div><div class="fields"><p>Task</p></div>'
      end

      it "should add task html escaped fields to hidden div after form" do
        output = ""
        @template.class_eval do
          define_method :after_nested_form do |assoc, &block|
            output << block.call
          end
        end
        @builder.fields_for(:tasks) { "<p>Task</p>".html_safe }
        @builder.link_to_add("Add", :tasks)
        output.should == '<div id="tasks_fields_blueprint" style="display: none">&lt;div class=&quot;fields&quot;&gt;&lt;p&gt;Task&lt;/p&gt;&lt;/div&gt;</div>'
      end
    end
  end
end
