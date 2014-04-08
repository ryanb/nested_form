copy_files = [
  {:from => "vendor/plugins/nested_form/vendor/assets/javascripts/*", :to => "app/public/javascripts/"}
]

copy_files.each do |file|
  FileUtils.cp("#{Rails.root}/#{file[:from]}", "#{Rails.root}/#{file[:to]}")
end
