module NestedForm
  module ViewHelper
    def nested_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => NestedForm::Builder)
      form_for(*(args << options), &block) 
      @after_nested_form_callback.call if @after_nested_form_callback
    end
    
    def after_nested_form(&block)
      @after_nested_form_callback = block
    end
  end
end

class ActionView::Base
  include NestedForm::ViewHelper
end
