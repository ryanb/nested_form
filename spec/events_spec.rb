require 'spec_helper'

describe 'Nested form', :js => true do
  include Capybara::DSL

  [:jquery, :prototype].each do |js_framework|
    
    url = case js_framework
    when :jquery then '/projects/new'
    when :prototype then '/projects/new?type=prototype'
    end

    context "with #{js_framework}" do
      context 'when field was added' do
        it 'emits general add event' do
          visit url
          click_link 'Add new task'

          page.should have_content 'Added some field'
        end

        it 'emits add event for current association' do
          visit url
          click_link 'Add new task'

          page.should have_content 'Added task field'
          page.should_not have_content 'Added milestone field'

          click_link 'Add new milestone'

          page.should have_content 'Added milestone field'
        end
      end

      context 'when field was removed' do
        it 'emits general remove event' do
          visit url
          click_link 'Add new task'
          click_link 'Remove'

          page.should have_content 'Removed some field'
        end

        it 'emits remove event for current association' do
          visit url
          2.times { click_link 'Add new task' }
          click_link 'Remove'

          page.should have_content 'Removed task field'
          page.should_not have_content 'Removed milestone field'

          click_link 'Add new milestone'
          click_link 'Remove milestone'

          page.should have_content 'Removed milestone field'
        end
      end
    end
  end
end