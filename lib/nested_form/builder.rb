module NestedForm
  class Builder < ::ActionView::Helpers::FormBuilder
    # ==== Signatures
    #
    #   link_to_add(content, association)
    #
    #   link_to_add(association) do
    #     # content
    #   end
    #
    def link_to_add(*args, &block)
      if block_given?
        content = @template.capture(&block)
        association = args.first
      else
        content = args.first
        association = args.second
      end
      @fields ||= {}
      @template.after_nested_form(association) do
        model_object = object.class.reflect_on_association(association).klass.new
        output = %Q[<div id="#{association}_fields_blueprint" style="display: none">].html_safe
        output << fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
        output.safe_concat('</div>')
        output
      end
      @template.link_to(content, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association)
    end

    # ==== Signatures
    #
    #   link_to_remove(content)
    #
    #   link_to_add do
    #     # content
    #   end
    #
    def link_to_remove(*args, &block)
      if block_given?
        content = @template.capture(&block)
      else
        content = args.first
      end
      hidden_field(:_destroy) + @template.link_to(content, "javascript:void(0)", :class => "remove_nested_fields")
    end

    def fields_for_with_nested_attributes(association_name, args, block)
      # TODO Test this better
      block ||= Proc.new { |fields| @template.render(:partial => "#{association_name.to_s.singularize}_fields", :locals => {:f => fields}) }
      @fields ||= {}
      @fields[association_name] = block
      super(association_name, args, block)
    end

    def fields_for_nested_model(name, object, options, block)
      output = '<div class="fields">'.html_safe
      output << super
      output.safe_concat('</div>')
      output
    end
  end
end
