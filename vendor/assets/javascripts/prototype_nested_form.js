document.observe('click', function(e, el) {
  if (el = e.findElement('form a.add_nested_fields')) {
    // Setup
    var assoc     = el.readAttribute('data-association');      // Name of child
    var target    = el.readAttribute('data-target');
    var blueprint = $(el.readAttribute('data-blueprint-id'));
    var content   = blueprint.readAttribute('data-blueprint'); // Fields template

    // Make the context correct by replacing <parents> with the generated ID
    // of each of the parent objects
    var context = (el.getOffsetParent('.fields').firstDescendant().readAttribute('name') || '').replace(new RegExp('\[[a-z_]+\]$'), '');

    // context will be something like this for a brand new form:
    // project[tasks_attributes][1255929127459][assignments_attributes][1255929128105]
    // or for an edit form:
    // project[tasks_attributes][0][assignments_attributes][1]
    if(context) {
      var parent_names = context.match(/[a-z_]+_attributes(?=\]\[(new_)?\d+\])/g) || [];
      var parent_ids   = context.match(/[0-9]+/g) || [];

      for(i = 0; i < parent_names.length; i++) {
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
    content     = content.replace(regexp, new_id);

    var field;
    if (target) {
      field = $$(target)[0].insert(content);
    } else {
      field = el.insert({ before: content });
    }
    field.fire('nested:fieldAdded', {field: field});
    field.fire('nested:fieldAdded:' + assoc, {field: field});
    return false;
  }
});

document.observe('click', function(e, el) {
  if (el = e.findElement('form a.remove_nested_fields')) {
    var hidden_field = el.previous(0),
        assoc = el.readAttribute('data-association'); // Name of child to be removed
    if(hidden_field) {
      hidden_field.value = '1';
    }
    var field = el.up('.fields').hide();
    field.fire('nested:fieldRemoved', {field: field});
    field.fire('nested:fieldRemoved:' + assoc, {field: field});
    return false;
  }
});
