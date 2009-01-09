var Captcha = Class.create();
Captcha.prototype = {
  initialize: function() {
    if ($bypassCaptcha) {
      return;
    }

    this.mask = $('captcha_mask');
    this.dlg  = $('captcha_dlg');
    this.txt  = $('recaptcha_response_field');

    this.txt.onkeydown = this.onKeyDown.bindAsEventListener(this);
    Event.observe(window, 'resize', this.onResize.bind(this));

    this.firstShow = true;  // Do not refresh reCAPTCHA on first show
  },

  show: function(formOrFunction) {
    this.formOrFunction = formOrFunction;

    if ($bypassCaptcha) {
      this.on200(null);
      return false;
    }

    var offset = $('container').positionedOffset();
    var left   = '' + offset[0] + 'px';
    var top    = '' + offset[1] + 'px';
    var width  = '' + $('container').getWidth()  + 'px';
    var height = '' + $('container').getHeight() + 'px';
    this.mask.setStyle({opacity: 0.9, left: left, top: top, width: width, height: height});
    this.dlg.setStyle({top: document.documentElement.scrollTop + 50 + 'px'});
    this.mask.show();
    this.dlg.show();
    this.onResize();

    if (!this.firstShow) {
      Recaptcha.reload ('r');
    } else {
      this.firstShow = false;
    }
    this.txt.disabled = false;
    Recaptcha.focus_response_field();
    this.txt.value = '';

    // Return false so that show() can be used directly in a form's onsubmit="return captcha.show(this)"
    return false;
  },

  onResize: function() {
    if (this.mask.display != 'none') {
      this.mask.setStyle({height: Element.getHeight($('container')) + 'px', width: Element.getWidth($('container')) + 'px'});
      this.dlg.setStyle({top: document.documentElement.scrollTop + 50 + 'px'});
    }
  },

  onKeyDown: function(evt) {
    if (evt.keyCode == Event.KEY_RETURN) {
      this.onSubmit();
    } else if (evt.keyCode == Event.KEY_ESC) {
      this.onCancel();
    }
  },

  onSubmit: function() {
    // Make sure that the captcha is only submitted once
    if (this.txt.disabled) {
      return;
    }
    this.txt.disabled = true;

    new Ajax.Request('/captcha/create', {
      method: 'post',
      parameters: 'recaptcha_challenge_field=' + $F('recaptcha_challenge_field') + '&recaptcha_response_field=' + this.txt.value,
      on200: this.on200.bind(this),
      on400: this.on400.bind(this)});
  },

  onCancel: function() {
    this.dlg.hide();
    this.mask.hide();
  },

  on200: function(request) {
    if ((typeof this.formOrFunction) == 'function') {
      this.formOrFunction();
    } else {
      this.formOrFunction.submit();
    }
    if (!$bypassCaptcha) {
      this.onCancel();
    }
  },

  on400: function(request) {
    this.txt.disabled = false;
	this.txt.value    = '';
	Recaptcha.reload ('r');
    Recaptcha.focus_response_field();
  }
};

var captcha;
Event.observe(window, 'load', function() {  captcha = new Captcha() }, false);
