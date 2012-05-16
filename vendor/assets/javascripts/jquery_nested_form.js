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
      var context = ($(link).closest('.fields').closestChild('input:first').attr('name') || '').replace(new RegExp('\[[a-z]+\]$'), '');


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

      var field = this.insertFields(content, assoc, link);
      $(link).closest("form")
        .trigger({ type: 'nested:fieldAdded', field: field })
        .trigger({ type: 'nested:fieldAdded:' + assoc, field: field });
      return false;
    },
    insertFields: function(content, assoc, link) {
      return $(content).insertBefore(link);
    },
    removeFields: function(e) {
      var link = e.currentTarget;
      var hiddenField = $(link).prev('input[type=hidden]');
      hiddenField.val('1');
      // if (hiddenField) {
      //   $(link).v
      //   hiddenField.value = '1';
      // }
      var field = $(link).closest('.fields');
      field.hide();
      $(link).closest("form").trigger({ type: 'nested:fieldRemoved', field: field });
      return false;
    }
  };

  window.nestedFormEvents = new NestedFormEvents();
  $('form a.add_nested_fields').live('click', nestedFormEvents.addFields);
  $('form a.remove_nested_fields').live('click', nestedFormEvents.removeFields);
});


// http://plugins.jquery.com/project/closestChild
/*
 * Copyright 2011, Tobias Lindig
 *
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 */
(function($) {
  $.fn.closestChild = function(selector) {
    // breadth first search for the first matched node
    if (selector && selector != '') {
      var queue = [];
      queue.push(this);
      while(queue.length > 0) {
        var node = queue.shift();
        var children = node.children();
        for(var i = 0; i < children.length; ++i) {
          var child = $(children[i]);
          if (child.is(selector)) {
            return child; //well, we found one
          }
          queue.push(child);
        }
      }
    }
    return $();//nothing found
  };
})(jQuery);