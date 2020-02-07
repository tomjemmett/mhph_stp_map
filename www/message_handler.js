Shiny.addCustomMessageHandler("openStpFile",
  function(message) {
    var win = window.open(message, '_blank');
    win.focus();
  });
