// Generated by CoffeeScript 1.6.3
$(document).ready(function() {
  var propagate;
  propagate = function() {
    var ca, _i, _len;
    for (_i = 0, _len = _ca.length; _i < _len; _i++) {
      ca = _ca[_i];
      ca.propagate();
    }
    return setTimeout(propagate, 100);
  };
  return propagate();
});
