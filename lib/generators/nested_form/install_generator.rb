module NestedForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end
      
      
      def copy_jquery_file
        copy_file 'nested_form.js', 'public/javascripts/nested_form.js'
      end
    end
  end
end