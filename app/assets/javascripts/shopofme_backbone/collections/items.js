ShopOfMe.Collections.Items = Backbone.Collection.extend({
	model: ShopOfMe.Models.Item,
	url: '/api/v1/recommendations',

	initialize: function(options) {
		this.filter = options.filter;
		this.url = options.url;
	},

	filtered: function() {
		var self = this;
		var filteredCollection = new ShopOfMe.Collections.Items({});

		this.applyFilter = function() {
			filteredCollection.reset(self.select(function(item) {return item.matchesFilters(self.filter);}));
		};

    //this.bind("change", applyFilter);
    this.bind("add",    this.applyFilter);
		//this.bind("remove", applyFilter);
    this.filter.bind("change", this.applyFilter);

		this.applyFilter();

		return filteredCollection;


	},

  forceUnbind: function() {
    //this.unbind("change", applyFilter);
    this.unbind("add", this.applyfilter);
    //this.unbind("remove", applyFilter);
    this.filter.unbind("change", this.applyfilter);
  }
});
