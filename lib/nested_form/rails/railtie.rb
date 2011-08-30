module NestedForm
  module Rails

    class Railtie < ::Rails::Railtie
      initializer 'nested_form' do |app|
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
