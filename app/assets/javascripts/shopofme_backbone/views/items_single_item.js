ShopOfMe.Views.ItemsSingleItem = Support.CompositeView.extend({
  tagName: "div",

  events: {
    "click a.likelink": "like",
    "click a.dislikelink": "dislike",
    "click a.outbound_link" : "follow_outbound_link"
  },

  initialize: function(options) {
    _.bindAll(this, "render");
  },

  render: function () {
    
    this.$el.html(JST['shopofme_backbone_templates/items/item']({ item: this.model }));
    this.$('.main_image').attr("src",this.model.get("image_path"));
    
    if (this.model.get('the_price') == '0') {

    } else {
      if (String(this.model.get('the_price')).indexOf('.') >= 0) {
        this.$('.item_price').html('£' + this.model.get('the_price'));
      } else {
        this.$('.item_price').html('£' + this.model.get('the_price') + '.00');
      }
    }

    if (this.model.get('the_retailer') === undefined) {
      this.$('.item_retailer').html(this.model.get('the_domain'));
    } else {
      this.$('.item_retailer').html(this.model.get('the_retailer').domain);
    }
    this.$('.outbound_link').attr('href', this.model.get('url'));

    this.$('.pin-it-button').attr('href',
    "http://pinterest.com/pin/create/button/?url=" + encodeURIComponent("http://my.shopofme.com/#items/"+this.model.get('id'))+"&media="+this.model.get("image_path")
    );

    if (this.model.get("status") == "likes") {
      // this.$('.item_highlight').css("background-color", "#92CCA6");
      this.$('.itemwhole').removeClass('disliked').addClass('liked');
    } else if (this.model.get("status") == "dislikes") {
      // this.$('.item_highlight').css("background-color", "#FF8D87");
      this.$('.itemwhole').removeClass('liked').addClass('disliked');
    }
    return this;
  },

  like: function(e) {
    ShopOfMe.user.like({item: this.model});
    // this.$('.item_highlight').css("background-color", "#92CCA6");
    this.$('.itemwhole').removeClass('disliked').addClass('liked');
    _kmq.push(['record', 'Liked an Item']);
    return false;
  },

  dislike: function(e) {
    ShopOfMe.user.dislike({item: this.model});
    // this.$('.item_highlight').css("background-color", "#FF8D87");
    this.$('.itemwhole').removeClass('liked').addClass('disliked');
    _kmq.push(['record', 'Disliked an Item']);
    return false;
  },

  follow_outbound_link: function(e) {
    window.open(this.model.get("affiliate_link"));
    _kmq.push(['record', 'Click through to retailers site',{"site" : this.model.get('the_retailer')}]);
    window.focus();
    e.preventDefault();
    return false;
  },

  forceUnbind: function() {
    this.remove();
    this.unbind();
  }

});
