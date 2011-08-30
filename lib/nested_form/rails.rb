module NestedForm
  module Rails
    if ::Rails.version < '3.1'
      require 'nested_form/rails/railtie'
    else
      require 'nested_form/rails/engine'
    end
  end
end
