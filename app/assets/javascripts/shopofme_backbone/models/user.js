ShopOfMe.Models.User = Backbone.Model.extend({
	initialize: function(defaults) {
		this.set(defaults);
	},

	genIdentifier: function(length) {
		var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('');

		if (! length) {
			length = Math.floor(Math.random() * chars.length);
		}

		var str = '';
		for (var i = 0; i < length; i++) {
			str += chars[Math.floor(Math.random() * chars.length)];
		}
		return str;
	},

	like: function(options) {
		$.post('/api/v1/items/' + options.item.get('id') + '/likes', {
			identifier: this.get('identifier'),
			bla: 'test'
		});
		options.item.set("status","likes");
	},

	dislike: function(options) {
		$.post('/api/v1/items/' + options.item.get('id') + '/dislikes', {
			identifier: this.get('identifier'),
			bla: 'test'
		});
		options.item.set("status","dislikes");
	}
});