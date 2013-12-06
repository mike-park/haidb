// should be included in parent page when our form is an iframe
// this is not necessary for the heroku site, it is necessary on
// the source site when our signup form is referenced via an iframe.

// currently hardcodes the name of haidb iframe as a-frame
jQuery(function() {
  if (window.addEventListener) { // all except IE < 9
    window.addEventListener('message', onMessage, false);
  } else {
    if (window.attachEvent) { // ie < 9
      window.attachEvent('onmessage', onMessage);
    }
  }
  window.onmessage = onMessage;

  function onMessage(e) {
    // IE sometimes gives this result
    if (e === undefined || e.data === undefined) {
      return;
    }

    var $iframe = jQuery('#a-frame');
    var params = e.data.toString().split('/');
    var eventName = params[0],
      data      = parseInt(params[1], 10),
      minHeight = 300;

    switch (eventName) {
      case 'setHeight':
        var height = data < minHeight ? minHeight : data;
        height = height + 50;  // slop for IE
        $iframe.height(height);
        break;
    }
  }
});
