// helper functions for Ajaxifying standard links and forms, and evaluating returned Javascript
$(function() {
  
  // ajax create forms
  $("form.new").ajaxForm({
    dataType: 'script',
    beforeSend: function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");},
    clearForm: true
  });
  
  // ajax update forms
  $("form.edit").ajaxForm({
  	type: "POST",
    data: {_method: "put"},
    dataType: 'script',
    beforeSend: function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}
  });
  
  // destroy links
  $("a.destroy").click( function() {
      $.ajax({
          type: "POST",
          data: {_method: "delete"},
          url: this.href,
          dataType: "script",
          beforeSend: function(xhr) {
            confirm('are you sure?');
            xhr.setRequestHeader("Accept", "text/javascript");
            }
      });
      return false;
  });
  
});