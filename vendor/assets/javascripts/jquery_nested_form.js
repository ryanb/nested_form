(function($) {
  window.NestedFormEvents = function() {
    this.addFields = $.proxy(this.addFields, this);
    this.removeFields = $.proxy(this.removeFields, this);
  };

  NestedFormEvents.prototype = {
    addFields: function(e) {
      // Setup
      var link      = e.currentTarget;
      var assoc     = $(link).data('association');                // Name of child
      var blueprint = $('#' + $(link).data('blueprint-id'));
      var content   = blueprint.data('blueprint');                // Fields template

      // Make the context correct by replacing <parents> with the generated ID
      // of each of the parent objects
      var context = ($(link).closest('.fields').closestChild('input, textarea, select').eq(0).attr('name') || '').replace(/\[[a-z_]+\]$/, '');

      if (context){
          var parentNames = context.match(/[a-z_]+_attributes(?=\]\[(new_)?.+\])/g) || [];
          var parentIds   = context.match(/[0-9]+/g) || [];

          content = this.replaceContentFromParents(content, assoc, parentNames, parentIds)
      }
      else{
          content = this.replaceContentFromParents(content, assoc)
      }

      var field = this.insertFields(content, assoc, link);
      // bubble up event upto document (through form)
      field
        .trigger({ type: 'nested:fieldAdded', field: field })
        .trigger({ type: 'nested:fieldAdded:' + assoc, field: field });
      return false;
    },
    newId: function() {
      return new Date().getTime();
    },
    insertFields: function(content, assoc, link) {
      var target = $(link).data('target');
      if (target) {      
        if($(link).closest('.fields').length > 0) {
          return $(content).appendTo($(link).closest('.fields').find($(link).data('target')));          
        } else {
          return $(content).appendTo($(target));          
        }
      } else {
        return $(content).insertBefore(link);
      }
    },
    removeFields: function(e) {
      var $link = $(e.currentTarget),
          assoc = $link.data('association'); // Name of child to be removed
      
      var hiddenField = $link.prev('input[type=hidden]');
      hiddenField.val('1');
      
      var field = $link.closest('.fields');
      field.hide();
      
      field
        .trigger({ type: 'nested:fieldRemoved', field: field })
        .trigger({ type: 'nested:fieldRemoved:' + assoc, field: field });
      return false;
    },
    replaceContentFromParents: function(content, assoc, parentNames, parentIds){
        parentNames = parentNames || [];
        parentIds = parentIds || [];

        if (parentNames.length > 0 && parentNames.length == parentIds.length){
            // we need to get a name pattern and id pattern that is mapped to parent
            var fullNameRegexp = "";     // regexp used to find the full name pattern in blueprint
            var fullIdRegexp = "";       // regexp used to find the full id   pattern in blueprint
            var fullNameReplace = "";    // name part from parents, eg. [parameters_attributes][0][children_attributes][1]
            var fullIdReplace = "";      // id   part from parents, eg. _parameters_attributes_0_children_attributes_1
            for (var i=0; i< parentNames.length; i++){
                fullNameRegexp += "\\[" + parentNames[i] + "\\]\\[.+?\\]";
                fullNameReplace += "[" + parentNames[i] + "][" + parentIds[i] + "]";
                fullIdRegexp += "_" + parentNames[i] + "_.+?";
                fullIdReplace += "_" + parentNames[i] + "_" + parentIds[i];

                if (i== parentNames.length -1){
                    fullIdRegexp += "(?=_" + assoc + "_attributes)"
                }
            }
            content = content.replace(new RegExp(fullNameRegexp, 'g'), fullNameReplace);
            content = content.replace(new RegExp(fullIdRegexp, 'g'), fullIdReplace);
        }

        // Make a unique ID for the new child
        var regexp  = new RegExp('new_' + assoc, 'g');
        var new_id  = this.newId();
        content     = $.trim(content.replace(regexp, new_id));
        return content;
    }
  };

  window.nestedFormEvents = new NestedFormEvents();
  $(document)
    .delegate('form a.add_nested_fields',    'click', nestedFormEvents.addFields)
    .delegate('form a.remove_nested_fields', 'click', nestedFormEvents.removeFields);
})(jQuery);

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
