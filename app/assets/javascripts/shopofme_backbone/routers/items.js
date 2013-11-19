ShopOfMe.Routers.Items = Support.SwappingRouter.extend({
  initialize: function(options) {
    this.el = $('#main_wrap');
    this.collection = options.collection;
    this.filter = options.filter;
    this.current_view = null;
  },

  routes: {
    "":"recommendations",
    "history":"history",
    "topitems":"topItems",
    "items/:id":"showItem"

  },

  recommendations: function() {
    $(".menu_rec").spin({ lines: 8, length: 4, width: 3, radius: 5 ,top: 15, left:184, color:'gray'} )
    self = this;
    this.filter.set('category', '-1');
    var view = new ShopOfMe.Views.ListingPage({items: this.collection, user: null, filters: this.filter, no_items_template: 'recs'});
    ShopOfMe.currently_selected_items = ShopOfMe.source_items;
    if (window.initial_source_items) {
      ShopOfMe.source_items.add(window.initial_source_items)
      this.stopAllSpinners();
      self.setActiveNav('rec_main_nav');
      self.swap2(view);
      self.swap(view);
      window.initial_source_items = null;
    } else {
    ShopOfMe.source_items.fetch({
      data: {
        identifier: ShopOfMe.user.get('identifier'),
        gender: ShopOfMe.filter.get('gender'),
        category: ShopOfMe.filter.get('category'),
        minPrice: ShopOfMe.filter.get('minPrice'),
        maxPrice: ShopOfMe.filter.get('maxPrice'),
        reset_page: true
      },
      silent: true,
      success: function() {
        self.stopAllSpinners();
        self.setActiveNav('rec_main_nav');
        ShopOfMe.source_items.add();
        self.swap2(view);
        self.swap(view);
      }
    });
    }
  },

  // history has to reload every time it's accessed as there's a good
  // chance there will be additional items if a user has liked anything.
  history :function() {
    $(".menu_history").spin({ lines: 8, length: 4, width: 3, radius: 5 ,top: 15, left:100, color:'gray'} )
    self = this;
    this.filter.softReset();
    var view = new ShopOfMe.Views.ListingPage({items: ShopOfMe.history_items, user: null, filters: this.filter, no_items_template: 'history'});
    ShopOfMe.currently_selected_items = ShopOfMe.history_items
    ShopOfMe.history_items.fetch({
      data: {
        identifier: ShopOfMe.user.get('identifier'),
        reset_page: true
      },
      silent: true,
      success: function() {
        self.stopAllSpinners();
        self.setActiveNav('history_main_nav');
        ShopOfMe.history_items.add();
        self.swap2(view);
        self.swap(view);
      }
    });
  },

  topItems :function() {
    this.filter.set('category', '-1');
    this.setActiveNav('hot_main_nav');
    var view = new ShopOfMe.Views.ListingPage({items: ShopOfMe.top_items, user: null, filters: this.filter, no_items_template: 'topitems'});
    this.swap2(view);
    this.swap(view);
  },

  showItem: function(item) {
    the_item = new ShopOfMe.Models.Item({id: item});
    var view = new ShopOfMe.Views.ListingPage({model: the_item, user: null, filters: this.filter});
    this.swap(view);
  },

  setActiveNav: function(id) {
    nav_options = ['rec_main_nav', 'history_main_nav', 'hot_main_nav'];
    _.each(nav_options, function(link) {
      if (link == id) {
        $('#' + link).css('font-weight','bold');
      } else {
        $('#' + link).css('font-weight','normal');
      }
    })
  },

  stopAllSpinners: function() {
    rec_spinner = $(".menu_rec").data().spinner;
    history_spinner = $(".menu_history").data().spinner;

    if (rec_spinner !== undefined) { rec_spinner.stop() }
    if (history_spinner !== undefined) { history_spinner.stop() }

  },

  swap2: function(view) {
    if (this.current_view != null) {
      this.current_view.forceUnbind();
    }
    this.current_view = view

  }

});
