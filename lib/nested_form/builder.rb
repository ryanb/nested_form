module NestedForm
  class Builder < ActionView::Helpers::FormBuilder

    def link_to_add(*args, &block)
      options = args.extract_options!.symbolize_keys
      association = args.pop

      unless object.respond_to?("#{association}_attributes=")
        raise ArgumentError, "Invalid association. Make sure that accepts_nested_attributes_for is used for #{association.inspect} association."
      end

      options[:class] = [options[:class], "add_nested_fields"].compact.join(" ")
      options["data-association"] = association
      options["data-blueprint-id"] = fields_blueprint_id = "#{association}_fields_blueprint"
      args << (options.delete(:href) || "javascript:void(0)")
      args << options

      @fields ||= {}
      @template.after_nested_form do
        model_object = object.class.reflect_on_association(association).klass.new
        @template.concat(%Q[<div id="#{association}_fields_blueprint" style="display: none">])
        fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
        @template.concat('</div>')
      end
      @template.link_to(*args, &block)
    end

    def link_to_remove(*args)
      options = args.extract_options!.symbolize_keys
      options[:class] = [options[:class], "remove_nested_fields"].compact.join(" ")
      args << (options.delete(:href) || "javascript:void(0)")
      args << options
      hidden_field(:_destroy) << @template.link_to(*args)
    end

    def fields_for_with_nested_attributes(association, args, block)
      @fields ||= {}
      @fields[association] = block
      super
    end

    def fields_for_nested_model(name, association, args, block)
      @template.concat "<div class='#{association.class.name.underscore}_fields fields'>"
      super
      @template.concat('</div>')
    end

  end
end
