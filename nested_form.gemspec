Gem::Specification.new do |s|
  s.name        = "nested_form"
  s.version     = "0.0.0"
  s.authors     = ["Ryan Bates", "Andrea Singh"]
  s.email       = "ryan@railscasts.com"
  s.homepage    = "http://github.com/ryanb/nested_form"
  s.summary     = "Gem to conveniently handle multiple models in a single form."
  s.description = "Gem to conveniently handle multiple models in a single form with Rails 3 and jQuery or Prototype."

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "nested_form"

  s.add_development_dependency "rspec", "~> 2.1.0"
  s.add_development_dependency "rr", "~> 0.10.11" # 1.0.0 has respond_to? issues: http://github.com/btakita/rr/issues/issue/43
  s.add_development_dependency "rails", "~> 3.0.0"
end
