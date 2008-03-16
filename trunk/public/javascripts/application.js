Event.addBehavior({

  /* Fade flash messages after a few seconds. */  
  "div.flash_banner": function() {
    setTimeout(function() {
      Effect.Fade(this);
    }.bind(this), 3000);
  }
  
});