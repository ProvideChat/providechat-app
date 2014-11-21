function default_style(content, field) {
  var style = {
    content: content,
    show: {
      event: 'click'
    },
    hide: {
      event: 'unfocus'
    },
    position: {
      my: 'bottom right',  // Position my top left...
      at: 'top right', // at the bottom right of...
      adjust: { x: 20 },
      target: $(field) // my target
    }
  };

  return style;
};