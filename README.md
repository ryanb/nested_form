# Nested Form

[<img src="https://secure.travis-ci.org/ryanb/nested_form.png?branch=master" alt="Build Status" />](http://travis-ci.org/ryanb/nested_form)

This is a Rails gem for conveniently manage multiple nested models in a single form. It does so in an unobtrusive way through jQuery or Prototype.

This gem only works with Rails 3. See the [rails2 branch](https://github.com/ryanb/nested_form/tree/rails2) for a plugin to work in Rails 2.

An example project showing how this works is available in the [complex-nested-forms/nested_form branch](https://github.com/ryanb/complex-form-examples/tree/nested_form).


## Setup

Add it to your Gemfile then run `bundle` to install it.

```ruby
gem "nested_form"
```

And then add it to the Asset Pipeline in the application.js file:

```
//= require jquery_nested_form
```

### Non Asset Pipeline Setup

If you do not use the asset pipeline, run this generator to create the JavaScript file.

```
rails g nested_form:install
```

You can then include the generated JavaScript in your layout.

```erb
<%= javascript_include_tag :defaults, "nested_form" %>
```

## Usage

Imagine you have a `Project` model that `has_many :tasks`. To be able to use this gem, you'll need to add `accepts_nested_attributes_for :tasks` to your Project model. If you wish to allow the nested objects to be destroyed, then add the `:allow_destroy => true` option to that declaration. If you don't have the `accepts_nested_attributes_for :tasks` you'll get a Missing Block Error. See the [accepts_nested_attributes_for documentation](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for) for details on all available options.

This will create a `tasks_attributes=` method, so you may need to add it to the `attr_accessible` array (`attr_accessible :tasks_attributes`).

Then use the `nested_form_for` helper method to enable the nesting.

```erb
<%= nested_form_for @project do |f| %>
```

You will then be able to use `link_to_add` and `link_to_remove` helper methods on the form builder in combination with fields_for to dynamically add/remove nested records.

```erb
<%= f.fields_for :tasks do |task_form| %>
  <%= task_form.text_field :name %>
  <%= task_form.link_to_remove "Remove this task" %>
<% end %>
<p><%= f.link_to_add "Add a task", :tasks %></p>
```


## SimpleForm and Formtastic Support

Use `simple_nested_form_for` or `semantic_nested_form_for` for SimpleForm and Formtastic support respectively.


## Partials

It is often desirable to move the nested fields into a partial to keep things organized. If you don't supply a block to fields_for it will look for a partial and use that.

```erb
<%= f.fields_for :tasks %>
```

In this case it will look for a partial called "task_fields" and pass the form builder as an `f` variable to it.


## JavaScript events

Sometimes you want to do some additional work after element was added or removed, but only
after DOM was _really_ modified. In this case simply listening for click events on
'Add new'/'Remove' link won't reliably work, because your code and code that inserts/removes
nested field will run concurrently.

This problem can be solved, because after adding or removing the field a set of custom events
is triggered on this field. Using form example from above, if you click on the "Add a task" link,
`nested:fieldAdded` and `nested:fieldAdded:tasks` will be triggered, while
`nested:fieldRemoved` and `nested:fieldRemoved:tasks` will be triggered if you click
"Remove this task" then.

These events bubble up the DOM tree, going through `form` element, until they reach the `document`.
This allows you to listen for the event and trigger some action accordingly. Field element, upon
which action was made, is passed along with the `event` object. In jQuery you can access it
via `event.field`, in Prototype the same field will be in `event.memo.field`.

For example, you have a date input in a nested field and you want to use jQuery datepicker
for it. This is a bit tricky, because you have to activate datepicker after field was inserted.

### jQuery

```javascript
$(document).on('nested:fieldAdded', function(event){
  // this field was just inserted into your form
  var field = event.field; 
  // it's a jQuery object already! Now you can find date input
  var dateField = field.find('.date');
  // and activate datepicker on it
  dateField.datepicker();
})
```

### Prototype

```javascript
document.observe('nested:fieldAdded', function(event){
  var field = event.memo.field;
  // it's already extended by Prototype
  var dateField = field.down('.date');
  dateField.datepicker();
})  
```

Second type of event (i.e. `nested:fieldAdded:tasks`) is useful then you have more than one type
of nested fields on a form (i.e. tasks and milestones) and want to distinguish, which exactly
was added/deleted.

See also [how to limit max count of nested fields](https://github.com/ryanb/nested_form/wiki/How-to:-limit-max-count-of-nested-fields)

## Enhanced jQuery JavaScript template

You can override default behavior of inserting new subforms into your form. For example:

```javascript
window.nestedFormEvents.insertFields = function(content, assoc, link) {
  return $(link).closest('form').find(assoc + '_fields').append($(content));
}
```

## Project Status

Unfortunately I have not had time to actively work on this project recently. If you find a critical issue where it does not work as documented please [ping me on Twitter](http://twitter.com/rbates) and I'll take a look.

## Contributing

If you have any issues with Nested Form not addressed above or in the [example project](http://github.com/ryanb/complex-form-examples/tree/nested_form), please add an [issue on GitHub](http://github.com/ryanb/nested_form/issues) or [fork the project](http://help.github.com/fork-a-repo) and send a [pull request](http://help.github.com/send-pull-requests). To run the specs:

```
bundle install
bundle exec rake spec:install
bundle exec rake spec:all
```

## Special Thanks

This gem was originally based on the solution by Tim Riley in his [complex-form-examples fork](https://github.com/timriley/complex-form-examples/tree/unobtrusive-jquery-deep-fix2).

Thank you Andrew Manshin for the Rails 3 transition, [Andrea Singh](https://github.com/madebydna) for converting to a gem and [Peter Giacomo Lombardo](https://github.com/pglombardo) for Prototype support.

Andrea also wrote a great [blog post](http://blog.madebydna.com/all/code/2010/10/07/dynamic-nested-froms-with-the-nested-form-gem.html) on the internal workings of this gem.

Thanks [Pavel Forkert](https://github.com/fxposter) for the SimpleForm and Formtastic support.
