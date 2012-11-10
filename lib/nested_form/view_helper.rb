require 'nested_form/builders'

module NestedForm
  module ViewHelper
    def nested_form_for(*args, &block)
      options = args.extract_options!.reverse_merge(:builder => NestedForm::Builder)
      form_for(*(args << options)) do |f|
        capture(f, &block).to_s << after_nested_form_callbacks
      end
    end

    if defined?(NestedForm::SimpleBuilder)
      def simple_nested_form_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::SimpleBuilder)
        simple_form_for(*(args << options)) do |f|
          capture(f, &block).to_s << after_nested_form_callbacks
        end
      end
    end

    if defined?(NestedForm::FormtasticBuilder)
      def semantic_nested_form_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::FormtasticBuilder)
        semantic_form_for(*(args << options)) do |f|
          capture(f, &block).to_s << after_nested_form_callbacks
        end
      end
    end

    if defined?(NestedForm::FormtasticBootstrapBuilder)
      def semantic_bootstrap_nested_form_for(*args, &block)
        options = args.extract_options!.reverse_merge(:builder => NestedForm::FormtasticBootstrapBuilder)
        semantic_form_for(*(args << options)) do |f|
          capture(f, &block).to_s << after_nested_form_callbacks
        end
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

    private
      def after_nested_form_callbacks
        @after_nested_form_callbacks ||= []
        fields = []
        while callback = @after_nested_form_callbacks.shift
          fields << callback.call
        end
        fields.join(" ").html_safe
      end
  end
end
