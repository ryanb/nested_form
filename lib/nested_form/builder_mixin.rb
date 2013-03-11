module NestedForm
  module BuilderMixin
    # Adds a link to insert a new associated records. The first argument is the name of the link, the second is the name of the association.
    #
    #   f.link_to_add("Add Task", :tasks)
    #
    # You can pass HTML options in a hash at the end and a block for the content.
    #
    #   <%= f.link_to_add(:tasks, :class => "add_task", :href => new_task_path) do %>
    #     Add Task
    #   <% end %>
    #
    # You can also pass <tt>model_object</tt> option with an object for use in
    # the blueprint, e.g.:
    #
    #   <%= f.link_to_add(:tasks, :model_object => Task.new(:name => 'Task')) %>
    #
    # See the README for more details on where to call this method.
    def link_to_add(*args, &block)
      options = args.extract_options!.symbolize_keys
      association = args.pop

      unless object.respond_to?("#{association}_attributes=")
        raise ArgumentError, "Invalid association. Make sure that accepts_nested_attributes_for is used for #{association.inspect} association."
      end

      model_object = options.delete(:model_object) do
        reflection = object.class.reflect_on_association(association)
        reflection.klass.new
      end

      options[:class] = [options[:class], "add_nested_fields"].compact.join(" ")
      options["data-association"] = association
      options["data-blueprint-id"] = fields_blueprint_id = fields_blueprint_id_for(association)
      args << (options.delete(:href) || "javascript:void(0)")
      args << options

      @fields ||= {}
      @template.after_nested_form(fields_blueprint_id) do
        blueprint = {:id => fields_blueprint_id, :style => 'display: none'}
        block, options = @fields[fields_blueprint_id].values_at(:block, :options)
        options[:child_index] = "new_#{association}"
        blueprint[:"data-blueprint"] = fields_for(association, model_object, options, &block).to_str
        @template.content_tag(:div, nil, blueprint)
      end
      @template.link_to(*args, &block)
    end

    # Adds a link to remove the associated record. The first argment is the name of the link.
    #
    #   f.link_to_remove("Remove Task")
    #
    # You can pass HTML options in a hash at the end and a block for the content.
    #
    #   <%= f.link_to_remove(:class => "remove_task", :href => "#") do %>
    #     Remove Task
    #   <% end %>
    #
    # See the README for more details on where to call this method.
    def link_to_remove(*args, &block)
      options = args.extract_options!.symbolize_keys
      options[:class] = [options[:class], "remove_nested_fields"].compact.join(" ")

      # Extracting "milestones" from "...[milestones_attributes][...]"
      md = object_name.to_s.match /(\w+)_attributes\]\[[\w\d]+\]$/
      association = md && md[1]
      options["data-association"] = association

      args << (options.delete(:href) || "javascript:void(0)")
      args << options
      hidden_field(:_destroy) << @template.link_to(*args, &block)
    end

    def fields_for_with_nested_attributes(association_name, *args)
      # TODO Test this better
      block = args.pop || Proc.new { |fields| @template.render(:partial => "#{association_name.to_s.singularize}_fields", :locals => {:f => fields}) }

      options = args.dup.extract_options!

      # Rails 3.0.x
      if options.empty? && args[0].kind_of?(Array)
        options = args[0].dup.extract_options!
      end

      @fields ||= {}
      @fields[fields_blueprint_id_for(association_name)] = { :block => block, :options => options }
      super(association_name, *(args << block))
    end

    def fields_for_nested_model(name, object, options, block)
      classes = 'fields'
      classes << ' marked_for_destruction' if object.respond_to?(:marked_for_destruction?) && object.marked_for_destruction?

      perform_wrap   = options.fetch(:nested_wrapper, true)
      perform_wrap &&= options[:wrapper] != false # wrap even if nil

      if perform_wrap
        @template.content_tag(:div, super, :class => classes)
      else
        super
      end
    end

    private

    def fields_blueprint_id_for(association)
      assocs = object_name.to_s.scan(/(\w+)_attributes/).map(&:first)
      assocs << association
      assocs.join('_') + '_fields_blueprint'
    end
  end
end
