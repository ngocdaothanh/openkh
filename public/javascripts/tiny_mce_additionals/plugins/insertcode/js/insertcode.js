var codeElem;

function init() {
	tinyMCEPopup.resizeToInnerSize();
	codeElem = tinyMCEPopup.editor.selection.getNode();
	if (codeElem.nodeName.toLowerCase() == 'code') {
		var code = codeElem.innerHTML.replace(/<br>/g, "\n").replace(/<br \/>/g, "\n").replace(/<br\/>/g, "\n");
		document.forms[0].codeContent.value = code;
	} else {
		codeElem = null;
	}
}

tinyMCEPopup.onInit.add(init);

function insertCode() {
	var code = document.forms[0].codeContent.value;
	if (codeElem == null) {
		tinyMCEPopup.editor.execCommand('mceInsertContent', false,
			'<pre><code>' + code + '</code></pre><p></p>');
	} else {
		codeElem.innerHTML = code;
	}
	tinyMCEPopup.close();
}

function resizeInputs() {
	var wHeight, wWidth;
	if (!tinyMCE.isMSIE) {
		 wHeight = self.innerHeight - 60;
		 wWidth = self.innerWidth - 16;
	} else {
		 wHeight = document.body.clientHeight - 75;
		 wWidth = document.body.clientWidth - 16;
	}

	document.forms[0].codeContent.style.height = Math.abs(wHeight) + 'px';
	document.forms[0].codeContent.style.width  = Math.abs(wWidth) + 'px';
}
