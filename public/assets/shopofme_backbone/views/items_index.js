ShopOfMe.Views.ItemsIndex=Support.CompositeView.extend({initialize:function(e){_.bindAll(this,"render"),this.collection.on("reset",this.render),this.filters=e.filters,this.child_views=[]},render:function(){return this.renderTemplate(),this.renderRecommendations(),this},renderTemplate:function(){this.$el.html(JST["shopofme_backbone_templates/items/index"]({items:this.collection}))},renderRecommendations:function(){var e=this;if(1>=this.collection.length)try{e.$("#the_recommendations_wrapper").append(JST["shopofme_backbone_templates/items/no_items_"+this.parent.no_items_template]({}))}catch(t){}else _.each(window.all_categories,function(t){e.filters.addCategory(t)}),this.collection.each(function(t){if(void 0!==t.get("id")){e.filters.updatePriceBounds(t.get("the_price"));var i=new ShopOfMe.Views.ItemsSingleItem({model:t});e.renderChild(i),e.child_views.push(i),e.$("#the_recommendations_wrapper").append(i.el)}})},forceUnbind:function(){_.each(this.child_views,function(e){e.forceUnbind()}),this.collection.unbind("reset",this.render),this.collection.forceUnbind(),this.remove(),this.unbind()}});