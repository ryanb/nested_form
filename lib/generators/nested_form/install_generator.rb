module NestedForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def copy_jquery_file
        copy_file 'nested_form.js', 'public/javascripts/nested_form.js'
      end
    end
  end
end