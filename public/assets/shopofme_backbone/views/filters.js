ShopOfMe.Views.Filters=Support.CompositeView.extend({initialize:function(){_.bindAll(this,"render"),this.model.categories.on("add",this.render),this.model.on("change:minPriceBound",this.render),this.model.on("change:maxPriceBound",this.render)},render:function(){return this.renderTemplate(),this},events:{"click .gender_filter":"changeGender","change .category_filter":"changeCategory","slide .sliderbar":"changePrice","mouseup .sliderbar":"setPrice"},renderTemplate:function(){this.$el.html(JST["shopofme_backbone_templates/filters/show"]({options:this.options,filter:this.model})),this.$(".sliderbar").slider({range:!0,min:Number(this.model.get("minPriceBound")),max:Number(this.model.get("maxPriceBound")),values:[Number(this.model.get("minPrice")),Number(this.model.get("maxPrice"))]}),this.$("#amount").text("£"+this.model.get("minPrice")+" - No Limit")},changePrice:function(e,t){200==t.values[1]?this.$("#amount").text("£"+t.values[0]+" - No Limit"):this.$("#amount").text("£"+t.values[0]+" - £"+t.values[1]),this.model.set({minPrice:t.values[0]},{silent:!0}),this.model.set({maxPrice:t.values[1]},{silent:!0})},setPrice:function(){this.model.set({maxPrice:this.model.get("maxPrice")},{silent:!1})},changeGender:function(e){localStorage.setItem("selected_gender",$(e.target).val()),this.model.categories.reset({silent:!0}),this.model.set({category:"-1"},{silent:!0}),this.model.set({gender:$(e.target).val()})},changeCategory:function(e){this.model.set({category:$(e.target).val()})},forceUnbind:function(){this.model.categories.unbind("add",this.render),this.model.unbind("change:minPriceBound",this.render),this.model.unbind("change:maxPriceBound",this.render),this.remove(),this.unbind()}});