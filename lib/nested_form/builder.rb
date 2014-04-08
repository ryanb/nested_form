module NestedForm
  class Builder < ActionView::Helpers::FormBuilder
    def link_to_add(name, association)
      @fields ||= {}
      @template.after_nested_form(association) do
        model_object = object.class.reflect_on_association(association).klass.new
        @template.concat(%Q[<div id="#{association}_fields_blueprint" style="display: none">])
        fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
        @template.concat('</div>')
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

    def fields_for_nested_model(name, object, args, block)
      @template.concat "<div class='#{object.class.name.underscore}_fields fields'>"
      if object.new_record?
        @template.fields_for(name, object, *args, &block)
      else
        @template.fields_for(name, object, *args) do |builder|
          block.call(builder)
          @template.concat builder.hidden_field(:id) unless builder.emitted_hidden_id?
        end
      end
      @template.concat '</div>'
    end

  end
end
