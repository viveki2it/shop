function _kms(e){setTimeout(function(){var t=document,i=t.getElementsByTagName("script")[0],n=t.createElement("script");n.type="text/javascript",n.async=!0,n.src=e,i.parentNode.insertBefore(n,i)},1)}var _kmq=_kmq||[],_kmk=_kmk||"786b8daf5efbd1581a637fe7a99c828e70fff720";_kms("//i.kissmetrics.com/i.js"),_kms("//doug1izaerwt3.cloudfront.net/"+_kmk+".1.js"),window.ShopOfMe={Models:{},Collections:{},Views:{},Routers:{},initialize:function(){self=this;var e=localStorage.getItem("selected_gender"),t="Women";void 0===e||"Men"!=e&&"Women"!=e||(t=e),this.filter=new ShopOfMe.Models.Filter({gender:t,category:"-1",minPrice:"0",maxPrice:"200",minPriceBound:"0",maxPriceBound:"200"}),this.user=new ShopOfMe.Models.User({}),null===localStorage.getItem("pickseUserIdent")?(localStorage.setItem("pickseUserIdent",this.user.genIdentifier(28)),this.user.set("is_first_time",!0)):this.user.set("is_first_time",!1),this.user.set("identifier",localStorage.getItem("pickseUserIdent")),_kmq.push(["identify",localStorage.getItem("pickseUserIdent")]);var i={};null!==localStorage.getItem("campaign")&&(i.campaign=localStorage.getItem("campaign")),_kmq.push(["record","visited my.shopofme.com",i]),this.source_items=new ShopOfMe.Collections.Items({filter:this.filter,url:"/api/v1/recommendations"}),this.source_items.reset(window.initial_source_items),this.history_items=new ShopOfMe.Collections.Items({filter:this.filter,url:"/api/v1/history"}),this.top_items=new ShopOfMe.Collections.Items({filter:this.filter,url:"/api/v1/top_items"}),this.currently_selected_items=this.source_items,new ShopOfMe.Routers.Items({collection:self.source_items,filter:self.filter}),Backbone.history.started||(Backbone.history.start(),Backbone.history.started=!0),this.top_items.fetch({data:{identifier:this.user.get("identifier"),reset_page:!0},silent:!0})}},$(document).ready(function(){ShopOfMe.initialize(),ShopOfMe.killscroll=!1,$(window).scroll(function(){$(window).scrollTop()+2e3>=$(document).height()&&ShopOfMe.killscroll===!1&&(ShopOfMe.killscroll=!0,ShopOfMe.currently_selected_items.fetch({data:{identifier:ShopOfMe.user.get("identifier"),filter:{gender:ShopOfMe.filter.get("gender"),category:ShopOfMe.filter.get("category"),minPrice:ShopOfMe.filter.get("minPrice"),maxPrice:ShopOfMe.filter.get("maxPrice")}},add:!0,silent:!0,success:function(){ShopOfMe.killscroll=!1,ShopOfMe.currently_selected_items.add()}}))})});