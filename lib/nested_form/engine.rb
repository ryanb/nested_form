require 'rails'

module NestedForm
  class Engine < ::Rails::Engine
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
