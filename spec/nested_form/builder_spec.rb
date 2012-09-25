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
          subject.link_to_add("Add", :tasks).should == '<a href="javascript:void(0)" class="add_nested_fields" data-association="tasks" data-blueprint-id="tasks_fields_blueprint">Add</a>'
          subject.link_to_add("Add", :tasks, :class => "foo", :href => "url").should == '<a href="url" class="foo add_nested_fields" data-association="tasks" data-blueprint-id="tasks_fields_blueprint">Add</a>'
          subject.link_to_add(:tasks) { "Add" }.should == '<a href="javascript:void(0)" class="add_nested_fields" data-association="tasks" data-blueprint-id="tasks_fields_blueprint">Add</a>'
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

      it "wraps nested fields marked for destruction with an additional class" do
        task = project.tasks.build
        task.mark_for_destruction
        fields = subject.fields_for(:tasks) { 'Task' }
        fields.should eq('<div class="fields marked_for_destruction">Task</div>')
      end

      it "puts blueprint into data-blueprint attribute" do
        task = project.tasks.build
        task.mark_for_destruction
        subject.fields_for(:tasks) { 'Task' }
        subject.link_to_add('Add', :tasks)
        output   = template.send(:after_nested_form_callbacks)
        expected = ERB::Util.html_escape '<div class="fields">Task</div>'
        output.should match(/div.+data-blueprint="#{expected}"/)
      end

      it "adds parent association name to the blueprint div id" do
        task = project.tasks.build
        task.milestones.build
        subject.fields_for(:tasks, :builder => builder) do |tf|
          tf.fields_for(:milestones, :builder => builder) { 'Milestone' }
          tf.link_to_add('Add', :milestones)
        end
        output = template.send(:after_nested_form_callbacks)
        output.should match(/div.+id="tasks_milestones_fields_blueprint"/)
      end
    end

    context "with options" do
      subject { builder.new(:item, project, template, {}, proc {}) }

      context "when model_object given" do
        it "should use it instead of new generated" do
          subject.fields_for(:tasks) {|f| f.object.name }
          subject.link_to_add("Add", :tasks, :model_object => Task.new(:name => 'for check'))
          output   = template.send(:after_nested_form_callbacks)
          expected = ERB::Util.html_escape '<div class="fields">for check</div>'
          output.should match(/div.+data-blueprint="#{expected}"/)
        end
      end
    end
  end
end
