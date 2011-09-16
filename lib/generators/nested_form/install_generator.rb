module NestedForm
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../../../../app/assets/javascripts/nested_form', __FILE__)

      def install
        if ::Rails.version < '3.1'
          js_framework = File.exists?('public/javascripts/prototype.js') ? :prototype : :jquery
          copy_file "#{js_framework}.js", 'public/javascripts/nested_form.js'
        else
          js_framework = defined?(Jquery::Rails::VERSION) ? :jquery : :prototype
          inject_into_file 'app/assets/javascripts/application.js',
            "//= require nested_form/#{js_framework}\n", :after => "require #{js_framework}\n"
        end
      end
    end
  end
end
