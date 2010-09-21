module NestedForm
  module ViewHelper
    def nested_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => NestedForm::Builder)
      output = form_for(*(args << options), &block)
      @after_nested_form_callbacks ||= []
      fields = @after_nested_form_callbacks.collect do |callback|
        callback.call
      end
      
      output << fields.join('').html_safe
    end
    
    def after_nested_form(&block)
      @after_nested_form_callbacks ||= []
      @after_nested_form_callbacks << block
    end
  end
end

class ActionView::Base
  include NestedForm::ViewHelper
end
