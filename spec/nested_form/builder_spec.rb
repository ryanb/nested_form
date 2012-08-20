require "spec_helper"

[NestedForm::Builder, NestedForm::SimpleBuilder, defined?(NestedForm::FormtasticBuilder) ? NestedForm::FormtasticBuilder : nil].compact.each do |builder|
  describe builder do
    let(:project) do
      Project.new
    end

    let(:template) do
      template = ActionView::Base.new
      template.output_buffer = ""
      template
    end

    context "with no options" do
      subject do
        builder.new(:item, project, template, {}, proc {})
      end

      describe '#link_to_add' do
        it "behaves similar to a Rails link_to" do
          subject.link_to_add("Add", :tasks).should == '<a href="javascript:void(0)" class="add_nested_fields" data-association="tasks">Add</a>'
          subject.link_to_add("Add", :tasks, :class => "foo", :href => "url").should == '<a href="url" class="foo add_nested_fields" data-association="tasks">Add</a>'
          subject.link_to_add(:tasks) { "Add" }.should == '<a href="javascript:void(0)" class="add_nested_fields" data-association="tasks">Add</a>'
        end

        context 'when missing association is provided' do
          it 'raises Argument error' do
            expect{ subject.link_to_add('Add', :bugs) }.to raise_error(ArgumentError,
                'Failed to find Project association by name "bugs"')
          end
        end
      end
      
      describe '#link_to_remove' do
        it "behaves similar to a Rails link_to" do
          subject.link_to_remove("Remove").should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="false" /><a href="javascript:void(0)" class="remove_nested_fields">Remove</a>'
          subject.link_to_remove("Remove", :class => "foo", :href => "url").should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="false" /><a href="url" class="foo remove_nested_fields">Remove</a>'
          subject.link_to_remove { "Remove" }.should == '<input id="item__destroy" name="item[_destroy]" type="hidden" value="false" /><a href="javascript:void(0)" class="remove_nested_fields">Remove</a>'
        end

        it 'has data-association attribute' do
          project.tasks.build
          subject.fields_for(:tasks, :builder => builder) do |tf|
            tf.link_to_remove 'Remove'
          end.should match '<a.+data-association="tasks">Remove</a>'
        end

        context 'when association is declared in a model by the class_name' do
          it 'properly detects association name' do
            project.assignments.build
            subject.fields_for(:assignments, :builder => builder) do |tf|
              tf.link_to_remove 'Remove'
            end.should match '<a.+data-association="assignments">Remove</a>'
          end
        end

        context 'when there is more than one nested level' do
          it 'properly detects association name' do
            task = project.tasks.build
            task.milestones.build
            subject.fields_for(:tasks, :builder => builder) do |tf|
              tf.fields_for(:milestones, :builder => builder) do |mf|
                mf.link_to_remove 'Remove'
              end
            end.should match '<a.+data-association="milestones">Remove</a>'
          end
        end
      end

      describe '#fields_for' do
        it "wraps nested fields each in a div with class" do
          2.times { project.tasks.build }
          subject.fields_for(:tasks) do
            "Task"
          end.should == '<div class="fields">Task</div><div class="fields">Task</div>'
        end
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
