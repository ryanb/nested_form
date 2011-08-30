module NestedForm
  module Rails

    class Engine < ::Rails::Engine
      config.before_configuration do
        ActiveSupport.on_load(:action_view) do
          require "nested_form/view_helper"
          class ActionView::Base
            include NestedForm::ViewHelper
          end
        end
      end
    end

  end
end
