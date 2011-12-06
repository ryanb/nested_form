require 'nested_form/builder_mixin'

module NestedForm
  class Builder < ::ActionView::Helpers::FormBuilder
    include ::NestedForm::BuilderMixin
  end

  begin
    require 'simple_form'
    class SimpleBuilder < ::SimpleForm::FormBuilder
      include ::NestedForm::BuilderMixin
    end
  rescue LoadError
  end

  begin
    require 'formtastic'

    # Formtastic 1.x compatibility
    ::Formtastic::FormBuilder = ::Formtastic::SemanticFormBuilder unless defined?(::Formtastic::FormBuilder)
    
    class FormtasticBuilder < ::Formtastic::FormBuilder
      include ::NestedForm::BuilderMixin
    end
  rescue LoadError
  end
end
