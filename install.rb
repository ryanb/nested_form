copy_files = [
  {
    :from => "vendor/plugins/nested_form/vendor/assets/javascripts/nested_form.js",
    :to => "#{Rails.root}/app/public/javascripts/"
  }
]

copy_files.each do |file|
  FileUtils.cp(file[:from], file[:to])
end
