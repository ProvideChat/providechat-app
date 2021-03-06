import React from 'react';
function toUnderscore(str) {
  // ChatListSection -> chat_list_section
  return str.replace(/([A-Z])/g, function($1) { return "_" + $1.toLowerCase(); }).slice(1);
}

window.renderReact = function(id, component, props) {
  var component = require("./components/" + toUnderscore(component));
  React.render(React.createElement(component, props), document.getElementById(id));
}
