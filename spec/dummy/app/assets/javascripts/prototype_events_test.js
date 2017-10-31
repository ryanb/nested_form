document.observe('dom:loaded', function() {
  var log = function(text) {
    var p = new Element('p').update(text);
    $('console').insert(p);
  };

  ['Added', 'Removed'].forEach(function(action) {
    document.observe('nested:field' + action, function(e) {
      log(action + ' some field')
    });

    document.observe('nested:field' + action + ':tasks', function(e) {
      log(action + ' task field')
    });

    document.observe('nested:field' + action + ':milestones', function(e) {
      log(action + ' milestone field')
    });
  });
});