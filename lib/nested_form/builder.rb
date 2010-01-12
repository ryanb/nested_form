module NestedForm
  class Builder < ActionView::Helpers::FormBuilder
    def link_to_add(name, association)
      @fields ||= {}
      @template.after_nested_form do
        model_object = object.class.reflect_on_association(association).klass.new
        fields = fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
        @template.content_tag(:div, fields, :style => "display: none")
      end
      @template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association)
    end
    
    def link_to_remove(name)
      hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end
    
    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      super
    end

    
    def fields_for_nested_model(name, association, args, block)
      @template.content_tag(:div, super, :class => "fields")
    end
  end
end
