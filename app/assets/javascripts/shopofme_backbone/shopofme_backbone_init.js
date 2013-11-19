// init kiss metrics
var _kmq = _kmq || [];
var _kmk = _kmk || '786b8daf5efbd1581a637fe7a99c828e70fff720';
function _kms(u){
setTimeout(function(){
  var d = document, f = d.getElementsByTagName('script')[0],
  s = d.createElement('script');
  s.type = 'text/javascript'; s.async = true; s.src = u;
  f.parentNode.insertBefore(s, f);
}, 1);
}
_kms('//i.kissmetrics.com/i.js');
_kms('//doug1izaerwt3.cloudfront.net/' + _kmk + '.1.js');

window.ShopOfMe = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function(data) {
    self = this;
    var gs = localStorage.getItem('selected_gender');
    var the_gender = "Women";
    if (gs !== undefined && (gs == "Men" || gs == "Women")) {
      the_gender = gs;
    }
    this.filter = new ShopOfMe.Models.Filter({
      gender: the_gender,
      category: '-1',
      minPrice: '0',
      maxPrice: '200',
      minPriceBound: '0',
      maxPriceBound: '200'

    });

    // initialise an empty user
    this.user = new ShopOfMe.Models.User({});

    // if there is an existing user, load it, otherwise generate a new identifier
    if (localStorage.getItem('pickseUserIdent') === null) {
      localStorage.setItem('pickseUserIdent',this.user.genIdentifier(28));
      this.user.set('is_first_time', true);
    } else {
      this.user.set('is_first_time', false);
    }

    // set the user identifier within the model
    this.user.set('identifier', localStorage.getItem('pickseUserIdent'));

    _kmq.push(['identify', localStorage.getItem('pickseUserIdent')]);
    var tracking_params = {};
    if (localStorage.getItem('campaign') !== null) {
      tracking_params.campaign = localStorage.getItem('campaign');
    }
    _kmq.push(['record', 'visited my.shopofme.com',tracking_params]);

    // create the raw item source, this is filtered and then provided to the view
    this.source_items = new ShopOfMe.Collections.Items({filter: this.filter, url: '/api/v1/recommendations'});
    this.source_items.reset(window.initial_source_items);
    this.history_items = new ShopOfMe.Collections.Items({filter: this.filter, url: '/api/v1/history'});
    this.top_items = new ShopOfMe.Collections.Items({filter: this.filter, url: '/api/v1/top_items'});

    this.currently_selected_items = this.source_items

    new ShopOfMe.Routers.Items({collection: self.source_items, filter: self.filter});
    if (!Backbone.history.started) {
      Backbone.history.start();
      Backbone.history.started = true;
    }
    // Fetch has to be done to get initial items because the identifier is only
    // available via javascript. reset_page tells the server to reset any internally
    // tracked lists of items which have been sent so far
    //this.source_items.fetch({
      //data: {
        //identifier: this.user.get('identifier'),
      //},
      //silent: true,
      //add: true,
      //success: function() {
        //ShopOfMe.source_items.add();
      //}
    //});
    
    //this.history_items.fetch({
      //data: {
        //identifier: this.user.get('identifier'),
        //reset_page: true
      //},
      //silent: true
    //});

    this.top_items.fetch({
      data: {
        identifier: this.user.get('identifier'),
        reset_page: true
      },
      silent: true
    });
    
    
  }
};

$(document).ready(function () {
  
  // initialize the backbone app.
  ShopOfMe.initialize();
  
  // Setup infinite scrolling, killscroll prevents multiple requests being made while
  // waiting for the first call to return.
  ShopOfMe.killscroll = false;
  $(window).scroll(function(){
    // increasing the value added to scrollTop will cause the next page to be loaded
    // earlier.
    if  ($(window).scrollTop()+2000 >= $(document).height()){
      if (ShopOfMe.killscroll === false) {
        ShopOfMe.killscroll = true;
        // Fetch new items, call with silent otherwise add and therefore render
        // will be called for every single item added rather than after all items
        // have been added. Instead trigger add() in the callback.
        ShopOfMe.currently_selected_items.fetch({
          data: {
            identifier: ShopOfMe.user.get('identifier'),
            filter: {
              gender: ShopOfMe.filter.get('gender'),
              category: ShopOfMe.filter.get('category'),
              minPrice: ShopOfMe.filter.get('minPrice'),
              maxPrice: ShopOfMe.filter.get('maxPrice')
            }
          },
          add: true,
          silent: true,
          success: function() {
            ShopOfMe.killscroll = false;
            ShopOfMe.currently_selected_items.add();
          }
        });
      }
    }
  });
});
