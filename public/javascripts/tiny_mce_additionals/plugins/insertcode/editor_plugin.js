tinymce.PluginManager.requireLangPack('insertcode');

(function() {
	tinymce.create('tinymce.plugins.InsertcodePlugin', {
		InsertcodePlugin : function(ed, url) {
			ed.addCommand('mceInsertcode', function() {
				ed.windowManager.open({
					file : url + '/insertcode.htm',
					width : 550,
					height : 500,
					inline : 1
				}, {
					plugin_url : url // Plugin absolute URL
				});
			});

			ed.addButton('insertcode', {
				title: 'insertcode.desc',
				cmd: 'mceInsertcode',
				image: url + '/img/insertcode.gif'
			});
			ed.onNodeChange.add(function(ed, cm, n) {
				return true;
			});
		},

		getInfo : function() {
			return {
				longname : 'insertcode plugin',
				author : 'Maxime Lardenois, Geshi removed by Ngoc DAO Thanh',
				authorurl : 'http://www.jpnp.org, http://cntt.tv',
				infourl : 'http://www.jpnp.org',
				version : "1.2"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('insertcode', tinymce.plugins.InsertcodePlugin);
})();
