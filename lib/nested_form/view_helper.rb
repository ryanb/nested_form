require 'nested_form/builders'

module NestedForm
  module ViewHelper
    def nested_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => NestedForm::Builder)
      output = form_for(*(args << options), &block)
      @after_nested_form_callbacks ||= []
      fields = @after_nested_form_callbacks.map do |callback|
        callback.call
      end
      output << fields.join(" ").html_safe
    end
    
    if defined?(NestedForm::SimpleBuilder)
      def simple_nested_form_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::SimpleBuilder)
        nested_form_for(*(args << options), &block)
      end
    end
    
    if defined?(NestedForm::FormtasticBuilder)
      def semantic_nested_form_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::FormtasticBuilder)
        nested_form_for(*(args << options), &block)
      end
    end

    def after_nested_form(association, &block)
      @associations ||= []
      @after_nested_form_callbacks ||= []
      unless @associations.include?(association)
        @associations << association
        @after_nested_form_callbacks << block
      end
    end
  end
end
