ShopOfMe.Models.Filter = Backbone.Model.extend({
	initialize: function(defaults) {
		this.set(defaults);
		this.categories = new ShopOfMe.Collections.Categories();
	},

  // add a new category to the category collection if it doesn't already
  // exist
  addCategory: function(the_cat) {

    isNew = this.categories.filter(function(cat) {
		return (cat.get('id') == the_cat.id) ? true : false;
    });

    if (isNew.length === 0 && the_cat.name != 'Men' && the_cat.name != 'Women' && the_cat.name !== '') {
      this.categories.add(the_cat);
    }

    // if (this.categories.where({id: cat.id}) < 1) {
    //
    // }
  },

  updatePriceBounds: function(price) {
      if (Number(price) < this.get('minPriceBound')) {
        //this.set({'minPriceBound': Number(price)}, {silent: true});
      }

      if (Number(price) > this.get('maxPriceBound')) {
        //this.set({'maxPriceBound': Number(price)}, {silent: true});
      }
  },

  softReset: function() {
    this.set({category: -1, minPrice: 0, maxPrice:200});
  }

});
