document.observe('click', function(e, el) {
	if (el = e.findElement('form a.add_nested_fields')) {
	  // Setup
	  var assoc   = el.readAttribute('data-association');           // Name of child
	  var content = $(assoc + '_fields_blueprint').innerHTML; // Fields template

	  // Make the context correct by replacing new_<parents> with the generated ID
	  // of each of the parent objects
	  var context = (el.getOffsetParent('.fields').firstDescendant().readAttribute('name') || '').replace(new RegExp('\[[a-z]+\]$'), '');

	  // context will be something like this for a brand new form:
	  // project[tasks_attributes][1255929127459][assignments_attributes][1255929128105]
	  // or for an edit form:
	  // project[tasks_attributes][0][assignments_attributes][1]
	  if(context) {
	    var parent_names = context.match(/[a-z_]+_attributes/g) || [];
	    var parent_ids   = context.match(/[0-9]+/g);

	    for(i = 0; i < parent_names.length; i++) {
	      if(parent_ids[i]) {
	        content = content.replace(
	          new RegExp('(\\[' + parent_names[i] + '\\])\\[.+?\\]', 'g'),
	          '$1[' + parent_ids[i] + ']'
	        )
	      }
	    }
	  }

	  // Make a unique ID for the new child
	  var regexp  = new RegExp('new_' + assoc, 'g');
	  var new_id  = new Date().getTime();
	  content     = content.replace(regexp, new_id);

	  el.insert({ before: content });
	  return false;
	}
});

document.observe('click', function(e, el) {
  	if (el = e.findElement('form a.remove_nested_fields')) {
		var hidden_field = el.previous(0);
		if(hidden_field) {
		  hidden_field.value = '1';
		}
		el.ancestors()[0].hide();
		return false;
	}
});
