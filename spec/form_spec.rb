require 'spec_helper'

describe 'NestedForm' do
  include Capybara::DSL
  
  def check_form
    page.should have_no_css('form .fields input[id$=name]')
    click_link 'Add new task'
    page.should have_css('form .fields input[id$=name]', :count => 1)
    find('form .tasks .fields input[id$=name]').should be_visible
    find('form .tasks .fields input[id$=_destroy]').value.should == 'false'
    
    click_link 'Remove'
    find('form .tasks .fields input[id$=_destroy]').value.should == '1'
    find('form .tasks .fields input[id$=name]').should_not be_visible
    
    click_link 'Add new task'
    click_link 'Add new task'
    fields = all('form .tasks .fields')
    fields.select { |field| field.visible? }.count.should == 2
    fields.reject { |field| field.visible? }.count.should == 1
  end
  
  it 'should work with jQuery', :js => true do
    visit '/projects/new'
    check_form
  end
    
  it 'should work with Prototype', :js => true do
    visit '/projects/new?type=prototype'
    check_form
  end

  it 'should work with jQuery using a table layout', :js => true do
    visit '/projects/new?layout=tabular'
    check_form
  end
  
  it 'should work with Prototype using a table layout', :js => true do
    pending
    visit '/projects/new?layout=tabular&type=prototype'
    check_form
  end

  
end