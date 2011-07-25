jQuery(function($) {

  window.NestedFormEvents = function() {
    this.addFields = $.proxy(this.addFields, this);
    this.removeFields = $.proxy(this.removeFields, this);
  };

  NestedFormEvents.prototype = {
    addFields: function(e) {
      // Setup
      var link    = e.currentTarget;
      var assoc   = $(link).attr('data-association');            // Name of child
      var content = $('#' + assoc + '_fields_blueprint').html(); // Fields template

      // Make the context correct by replacing new_<parents> with the generated ID
      // of each of the parent objects
      var context = ($(link).closest('.fields').find('input:first').attr('name') || '').replace(new RegExp('\[[a-z]+\]$'), '');

      // context will be something like this for a brand new form:
      // project[tasks_attributes][new_1255929127459][assignments_attributes][new_1255929128105]
      // or for an edit form:
      // project[tasks_attributes][0][assignments_attributes][1]
      if (context) {
        var parentNames = context.match(/[a-z_]+_attributes/g) || [];
        var parentIds   = context.match(/(new_)?[0-9]+/g) || [];

        for(var i = 0; i < parentNames.length; i++) {
          if(parentIds[i]) {
            content = content.replace(
              new RegExp('(_' + parentNames[i] + ')_.+?_', 'g'),
              '$1_' + parentIds[i] + '_');

            content = content.replace(
              new RegExp('(\\[' + parentNames[i] + '\\])\\[.+?\\]', 'g'),
              '$1[' + parentIds[i] + ']');
          }
        }
      }

      // Make a unique ID for the new child
      var regexp  = new RegExp('new_' + assoc, 'g');
      var new_id  = new Date().getTime();
      content     = content.replace(regexp, "new_" + new_id);

      // Add validators for the new field
      var validators = window[assoc + '_validations_blueprint'];
      if (validators) {
        var form = $(link).closest("form");
        var object_name = $(content).find(":input").first().attr("name").replace(new RegExp("\\[[^\\[\\]]*\\]$"), "");
        for (var field in validators) {
          window[form.attr("id")].validators[object_name + "[" + field + "]"] = validators[field];
        }
      }
      
      var field = this.insertFields(content, assoc, link);
      $(link).closest("form")
        .trigger({ type: 'nested:fieldAdded', field: field })
        .trigger({ type: 'nested:fieldAdded:' + assoc, field: field });
      return false;
    },
    insertFields: function(content, assoc, link) {
      return $(content).appendTo("#" + assoc + "-fields");
    },
    removeFields: function(e) {
      var link = e.currentTarget;
      var hiddenFields = $(link).closest('.fields').find('input[type=hidden]');
      var hiddenField = $(link).prev('input[type=hidden]')[0];
      if (hiddenField) {
        hiddenField.value = '1';
      }
      var field = $(link).closest('.fields');
      field.hide().html(hiddenFields);
      $(link).closest("form").trigger({ type: 'nested:fieldRemoved', field: field });
      return false;
    }
  };

  window.nestedFormEvents = new NestedFormEvents();
  $('form a.add_nested_fields').live('click', nestedFormEvents.addFields);
  $('form a.remove_nested_fields').live('click', nestedFormEvents.removeFields);
});
