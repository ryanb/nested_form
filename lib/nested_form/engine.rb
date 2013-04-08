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

  class Railtie < Rails::Railtie
    config.nested_form = ActiveSupport::OrderedOptions.new
    #set to true for global use of length validators to hide and show
    #add and remove buttons
    config.nested_form.use_length_validators = false
  end
end
