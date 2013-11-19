ShopOfMe.Views.ListingPage = Support.CompositeView.extend({
  initialize: function(options) {
    _.bindAll(this, "render");
    // this.collection.on("add", this.render);
    // this.collection.on("reset", this.render);
    this.items = options.items;
    this.user = options.user;
    this.filters = options.filters;
    this.no_items_template = options.no_items_template;
    this.child_views = [];
  },

  render: function () {
    this.renderTemplate();
    // if the intro box has not been hidden, then render it
    if ((localStorage.getItem('shopofmeShownIntro') !== '1') && window.show_intro === true) {
      this.renderIntroBox();
    }
    this.renderScore();
    this.renderFilters();
    if (this.model) {
      this.renderItemDetail();
    } else {
      this.renderItemList();
    }
    return this;
  },

  renderTemplate: function() {
    this.$el.html(JST['shopofme_backbone_templates/items/listing_page']());
  },

  // render the introductory text above the item listing, added initially for
  // stumbleupon users.
  renderIntroBox: function() {
    var self = this
    this.$('#items').append(JST['shopofme_backbone_templates/items/intro_box']());
    
    // set any continue links to hide the introduction box and set a cookie to
    // say that the box has been shown and hidden so should not be shown again
    this.$('#items p.close_intro').bind('click',function() {
      self.$('.intro_box').hide();
      localStorage.setItem('shopofmeShownIntro', '1');
    });
  },

  renderScore: function() {
    var self = this;
  },

  renderFilters: function() {
    var self = this;
    the_filter_view = new ShopOfMe.Views.Filters({model: this.filters});
    this.child_views.push(the_filter_view);
    self.renderChild(the_filter_view);
    self.$('#the_sidebar').append(the_filter_view.el);
    this.filters.bind("change",function(filters) {
      self.items.fetch({
      data: {
        identifier: ShopOfMe.user.get('identifier'),
        filter: {
          gender: self.filters.get('gender'),
          category: self.filters.get('category'),
          minPrice: self.filters.get('minPrice'),
          maxPrice: self.filters.get('maxPrice')
        }
      },
      silent: true,
      add: true,
      success: function() {
        self.items.add();
      }}
      );
    });
  },

  renderItemList: function() {
    self = this;
    this.filtered_items = this.items.filtered();
    this.filtered_items.add();
    the_list_view = new ShopOfMe.Views.ItemsIndex({collection: this.filtered_items, filters: this.filters});
    this.child_views.push(the_list_view);
    self.renderChild(the_list_view);
    self.$('#items').append(the_list_view.el);
  },

  renderItemDetail: function() {
    self = this;
    this.model.fetch({success: function() {
      
      self.$('#items').html(JST['shopofme_backbone_templates/items/item_detail']());
      self.$('.main_image').attr("src",self.model.get("image_link"));
      self.$('.item_price').html('£' + self.model.get('the_price') + '.00');
      if (self.model.get('the_retailer') === undefined) {
        self.$('.item_retailer').html(self.model.get('the_domain'));
      } else {
        self.$('.item_retailer').html(self.model.get('the_retailer'));
      }
      self.$('.outbound_link').attr('href', self.model.get('url'));
    }});
  },

  forceUnbind: function() {
    _.each(this.child_views.reverse, function(view) {
      view.forceUnbind();
    });
    this.remove();
    this.unbind();
  }

});
