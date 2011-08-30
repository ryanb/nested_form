module NestedForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/assets/javascripts/nested_form', __FILE__)

      def install
        if File.exists?('public/javascripts/prototype.js')
          copy_file 'prototype.js', 'public/javascripts/nested_form.js'
        else
          copy_file 'jquery.js', 'public/javascripts/nested_form.js'
        end
      end
    end
  end
end
