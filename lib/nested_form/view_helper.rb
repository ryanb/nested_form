module NestedForm
  module ViewHelper
    def nested_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => NestedForm::Builder)
      form_for(*(args << options), &block) 
      @after_nested_form_callbacks ||= []
      @after_nested_form_callbacks.each do |callback|
        callback.call
      end
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
