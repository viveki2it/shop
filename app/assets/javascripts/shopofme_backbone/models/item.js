ShopOfMe.Models.Item = Backbone.Model.extend({
	urlRoot: '/api/v1/items',

	isGender: function(gender) {
		return this.get('gender') == gender;
		// return true;
	},

	matchesFilters: function(filter) {
		var matches = true;

    // legacy mappings to ensure consistent gender terminology

    var the_gender = this.get('gender')
    if (the_gender == 'Female') 
      {the_gender = 'Women'}
    else if (the_gender == 'Male')
      {the_gender = 'Men'}
		matches = the_gender == filter.get('gender') ? matches : false;
		if ((filter.get('category') != -1) && (this.get('all_master_categories') !== undefined) ) {
			var categories = this.get('all_master_categories').split(',');
			matches = (categories.indexOf(filter.get('category')) != -1) ? matches : false;
		}
    item_price = Number(this.get('the_price'));
		if (filter.get('maxPrice') != '200') {
      matches = (item_price != 0) ? matches : false;
      matches = ((item_price >= filter.get('minPrice')) && (item_price <= filter.get('maxPrice'))) ? matches : false;
    } else {
      matches = (item_price >= filter.get('minPrice'))  ? matches : false;
    }
    return matches;
	}
});
