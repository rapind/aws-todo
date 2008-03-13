
Event.addBehavior({

  /* Fade flash messages after a few seconds. */  
  "div.notice": function() {
    setTimeout(function() {
      Effect.Fade(this);
    }.bind(this), 3000);
  }
  
});

function observe_form(task_id_number) {
  new Form.EventObserver('task_form' + task_id_number, 
    function(element, value) { 
      new Ajax.Request('/tasks/update/' + task_id_number, 
      { asynchronous:true, 
        evalScripts:true, 
        onLoading:function(request) { 
          Form.disable('task_form' + task_id_number);
          Element.show('spinner' + task_id_number); },
        onComplete:function(request) { 
          Form.enable('task_form' + task_id_number) },   
        parameters:Form.serialize('task_form' + task_id_number)})});
}
