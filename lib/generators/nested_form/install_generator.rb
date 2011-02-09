module NestedForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end
      
      
      def copy_jquery_file
        stat = File.stat('public/javascripts/prototype.js')
        if stat.file?
          copy_file 'prototype_nested_form.js', 'public/javascripts/nested_form.js'
        else
          copy_file 'jquery_nested_form.js', 'public/javascripts/nested_form.js'
        end
      end
    end
  end
end
