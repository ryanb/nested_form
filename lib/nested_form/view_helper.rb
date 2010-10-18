module NestedForm
  module ViewHelper
    def nested_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => NestedForm::Builder)
      output = form_for(*(args << options), &block)
      @after_nested_form_callbacks ||= {}
      fields = @after_nested_form_callbacks.map do |key, callback|
        callback.call
      end
      output << fields.join(" ").html_safe
    end
    
    def after_nested_form(association, &block)
      @after_nested_form_callbacks ||= {}
      @after_nested_form_callbacks[association] = block
    end
  end
end

class ActionView::Base
  include NestedForm::ViewHelper
end