ShopOfMe.Views.ItemsIndex = Support.CompositeView.extend({
  initialize: function(options) {
    _.bindAll(this, "render");
    //this.collection.on("add", this.render);
    this.collection.on("reset", this.render);
    this.filters = options.filters;
    this.child_views = [];
  },

  render: function () {
    this.renderTemplate();
    this.renderRecommendations();
    return this;
  },

  renderTemplate: function() {
    this.$el.html(JST['shopofme_backbone_templates/items/index']({ items: this.collection }));
  },

  renderRecommendations: function() {
    var self = this;
    
    //this.filters.set({'minPriceBound': Number(this.collection.models[0].get('the_price'))}, {silent: true});
    //this.filters.set({'maxPriceBound': Number(this.collection.models[0].get('the_price'))}, {silent: true});
    
    if (this.collection.length <= 1) {
      try {
      self.$('#the_recommendations_wrapper').append(
        
          JST['shopofme_backbone_templates/items/no_items_' + this.parent.no_items_template]({})
      );
      } catch(err) {

        }
    } else {
      _.each(window.all_categories, function(cat) {
        self.filters.addCategory(cat);
      });
      this.collection.each(function(the_item) {
        if (the_item.get('id') !== undefined) {
          //_.each(the_item.get('master_categories'),function(the_cat) {
          //  self.filters.addCategory(the_cat.master_category);
          //});
          self.filters.updatePriceBounds(the_item.get('the_price'));
          var the_item_view = new ShopOfMe.Views.ItemsSingleItem({model: the_item});
          self.renderChild(the_item_view);
          self.child_views.push(the_item_view);
          self.$('#the_recommendations_wrapper').append(the_item_view.el);
        }
      });
    }
    
  },

  forceUnbind: function() {
    _.each(this.child_views, function(view) {
      view.forceUnbind();
    });
    this.collection.unbind("reset", this.render);
    this.collection.forceUnbind();
    this.remove();
    this.unbind();
  }
});
