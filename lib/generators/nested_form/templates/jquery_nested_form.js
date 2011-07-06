jQuery(function($) {
  $('form a.add_nested_fields').live('click', function() {
    // Setup
    var assoc   = $(this).attr('data-association');            // Name of child
    var content = $('#' + assoc + '_fields_blueprint').html(); // Fields template

    var insert_node   = $(this).attr('data-insert-node') || this;            // Insertion Node
    var insert_position   = $(this).attr('data-insert-position') || 'before';            // Insertion Position

    // Make the context correct by replacing new_<parents> with the generated ID
    // of each of the parent objects
    var context = ($(this).closest('.fields').find('input:first').attr('name') || '').replace(new RegExp('\[[a-z]+\]$'), '');

    // context will be something like this for a brand new form:
    // project[tasks_attributes][new_1255929127459][assignments_attributes][new_1255929128105]
    // or for an edit form:
    // project[tasks_attributes][0][assignments_attributes][1]
    if(context) {
      var parent_names = context.match(/[a-z_]+_attributes/g) || [];
      var parent_ids   = context.match(/(new_)?[0-9]+/g) || [];

      for(var i = 0; i < parent_names.length; i++) {
        if(parent_ids[i]) {
          content = content.replace(
            new RegExp('(_' + parent_names[i] + ')_.+?_', 'g'),
            '$1_' + parent_ids[i] + '_');

          content = content.replace(
            new RegExp('(\\[' + parent_names[i] + '\\])\\[.+?\\]', 'g'),
            '$1[' + parent_ids[i] + ']');
        }
      }
    }

    // Make a unique ID for the new child
    var regexp  = new RegExp('new_' + assoc, 'g');
    var new_id  = new Date().getTime();
    content     = content.replace(regexp, "new_" + new_id);


    insert_node = $(this).closest("form").find(insert_node);
//    var field = $(content).insertBefore(this);
    switch(insert_position){
    case 'before':
        var field = $(content).insertBefore(insert_node);
        break;
    case 'after':
        var field = $(content).insertAfter(insert_node);
        break;
    case 'top':
        var field = $(content).prependTo(insert_node);
        break;
    case 'bottom':
        var field = $(content).appendTo(insert_node);
        break;
    default:
        var field = $(content).insertBefore(this);
    }

    $(this).closest("form").trigger({type: 'nested:fieldAdded', field: field});
    return false;
  });

  $('form a.remove_nested_fields').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    $(this).closest('.fields').hide();
    $(this).closest("form").trigger('nested:fieldRemoved');
    return false;
  });
});
