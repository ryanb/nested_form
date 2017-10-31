$(function() {
  var log = function(text) {
    $('<p/>', {text: text}).appendTo('#console');
  };

  ['Added', 'Removed'].forEach(function(action) {
    $(document).on('nested:field' + action, function(e) {
      log(action + ' some field')
    });

    $(document).on('nested:field' + action + ':tasks', function(e) {
      log(action + ' task field')
    });

    $(document).on('nested:field' + action + ':milestones', function(e) {
      log(action + ' milestone field')
    });
  });
});