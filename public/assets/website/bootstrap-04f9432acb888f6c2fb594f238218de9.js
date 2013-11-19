/* ===================================================
 * bootstrap-transition.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#transitions
 * ===================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */
!function(e){e(function(){"use strict";e.support.transition=function(){var e=function(){var e,t=document.createElement("bootstrap"),i={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd",msTransition:"MSTransitionEnd",transition:"transitionend"};for(e in i)if(void 0!==t.style[e])return i[e]}();return e&&{end:e}}()})}(window.jQuery),/* ==========================================================
 * bootstrap-alert.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#alerts
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */
!function(e){"use strict";var t='[data-dismiss="alert"]',i=function(i){e(i).on("click",t,this.close)};i.prototype.close=function(t){function i(){n.trigger("closed").remove()}var n,s=e(this),r=s.attr("data-target");r||(r=s.attr("href"),r=r&&r.replace(/.*(?=#[^\s]*$)/,"")),n=e(r),t&&t.preventDefault(),n.length||(n=s.hasClass("alert")?s:s.parent()),n.trigger(t=e.Event("close")),t.isDefaultPrevented()||(n.removeClass("in"),e.support.transition&&n.hasClass("fade")?n.on(e.support.transition.end,i):i())},e.fn.alert=function(t){return this.each(function(){var n=e(this),s=n.data("alert");s||n.data("alert",s=new i(this)),"string"==typeof t&&s[t].call(n)})},e.fn.alert.Constructor=i,e(function(){e("body").on("click.alert.data-api",t,i.prototype.close)})}(window.jQuery),/* ============================================================
 * bootstrap-button.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#buttons
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function(e){"use strict";var t=function(t,i){this.$element=e(t),this.options=e.extend({},e.fn.button.defaults,i)};t.prototype.setState=function(e){var t="disabled",i=this.$element,n=i.data(),s=i.is("input")?"val":"html";e+="Text",n.resetText||i.data("resetText",i[s]()),i[s](n[e]||this.options[e]),setTimeout(function(){"loadingText"==e?i.addClass(t).attr(t,t):i.removeClass(t).removeAttr(t)},0)},t.prototype.toggle=function(){var e=this.$element.parent('[data-toggle="buttons-radio"]');e&&e.find(".active").removeClass("active"),this.$element.toggleClass("active")},e.fn.button=function(i){return this.each(function(){var n=e(this),s=n.data("button"),r="object"==typeof i&&i;s||n.data("button",s=new t(this,r)),"toggle"==i?s.toggle():i&&s.setState(i)})},e.fn.button.defaults={loadingText:"loading..."},e.fn.button.Constructor=t,e(function(){e("body").on("click.button.data-api","[data-toggle^=button]",function(t){var i=e(t.target);i.hasClass("btn")||(i=i.closest(".btn")),i.button("toggle")})})}(window.jQuery),/* ==========================================================
 * bootstrap-carousel.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#carousel
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */
!function(e){"use strict";var t=function(t,i){this.$element=e(t),this.options=i,this.options.slide&&this.slide(this.options.slide),"hover"==this.options.pause&&this.$element.on("mouseenter",e.proxy(this.pause,this)).on("mouseleave",e.proxy(this.cycle,this))};t.prototype={cycle:function(t){return t||(this.paused=!1),this.options.interval&&!this.paused&&(this.interval=setInterval(e.proxy(this.next,this),this.options.interval)),this},to:function(t){var i=this.$element.find(".active"),n=i.parent().children(),s=n.index(i),r=this;if(!(t>n.length-1||0>t))return this.sliding?this.$element.one("slid",function(){r.to(t)}):s==t?this.pause().cycle():this.slide(t>s?"next":"prev",e(n[t]))},pause:function(e){return e||(this.paused=!0),clearInterval(this.interval),this.interval=null,this},next:function(){return this.sliding?void 0:this.slide("next")},prev:function(){return this.sliding?void 0:this.slide("prev")},slide:function(t,i){var n=this.$element.find(".active"),s=i||n[t](),r=this.interval,o="next"==t?"left":"right",a="next"==t?"first":"last",l=this,c=e.Event("slide");if(this.sliding=!0,r&&this.pause(),s=s.length?s:this.$element.find(".item")[a](),!s.hasClass("active")){if(e.support.transition&&this.$element.hasClass("slide")){if(this.$element.trigger(c),c.isDefaultPrevented())return;s.addClass(t),s[0].offsetWidth,n.addClass(o),s.addClass(o),this.$element.one(e.support.transition.end,function(){s.removeClass([t,o].join(" ")).addClass("active"),n.removeClass(["active",o].join(" ")),l.sliding=!1,setTimeout(function(){l.$element.trigger("slid")},0)})}else{if(this.$element.trigger(c),c.isDefaultPrevented())return;n.removeClass("active"),s.addClass("active"),this.sliding=!1,this.$element.trigger("slid")}return r&&this.cycle(),this}}},e.fn.carousel=function(i){return this.each(function(){var n=e(this),s=n.data("carousel"),r=e.extend({},e.fn.carousel.defaults,"object"==typeof i&&i);s||n.data("carousel",s=new t(this,r)),"number"==typeof i?s.to(i):"string"==typeof i||(i=r.slide)?s[i]():r.interval&&s.cycle()})},e.fn.carousel.defaults={interval:5e3,pause:"hover"},e.fn.carousel.Constructor=t,e(function(){e("body").on("click.carousel.data-api","[data-slide]",function(t){var i,n=e(this),s=e(n.attr("data-target")||(i=n.attr("href"))&&i.replace(/.*(?=#[^\s]+$)/,"")),r=!s.data("modal")&&e.extend({},s.data(),n.data());s.carousel(r),t.preventDefault()})})}(window.jQuery),/* =============================================================
 * bootstrap-collapse.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#collapse
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function(e){"use strict";var t=function(t,i){this.$element=e(t),this.options=e.extend({},e.fn.collapse.defaults,i),this.options.parent&&(this.$parent=e(this.options.parent)),this.options.toggle&&this.toggle()};t.prototype={constructor:t,dimension:function(){var e=this.$element.hasClass("width");return e?"width":"height"},show:function(){var t,i,n,s;if(!this.transitioning){if(t=this.dimension(),i=e.camelCase(["scroll",t].join("-")),n=this.$parent&&this.$parent.find("> .accordion-group > .in"),n&&n.length){if(s=n.data("collapse"),s&&s.transitioning)return;n.collapse("hide"),s||n.data("collapse",null)}this.$element[t](0),this.transition("addClass",e.Event("show"),"shown"),this.$element[t](this.$element[0][i])}},hide:function(){var t;this.transitioning||(t=this.dimension(),this.reset(this.$element[t]()),this.transition("removeClass",e.Event("hide"),"hidden"),this.$element[t](0))},reset:function(e){var t=this.dimension();return this.$element.removeClass("collapse")[t](e||"auto")[0].offsetWidth,this.$element[null!==e?"addClass":"removeClass"]("collapse"),this},transition:function(t,i,n){var s=this,r=function(){"show"==i.type&&s.reset(),s.transitioning=0,s.$element.trigger(n)};this.$element.trigger(i),i.isDefaultPrevented()||(this.transitioning=1,this.$element[t]("in"),e.support.transition&&this.$element.hasClass("collapse")?this.$element.one(e.support.transition.end,r):r())},toggle:function(){this[this.$element.hasClass("in")?"hide":"show"]()}},e.fn.collapse=function(i){return this.each(function(){var n=e(this),s=n.data("collapse"),r="object"==typeof i&&i;s||n.data("collapse",s=new t(this,r)),"string"==typeof i&&s[i]()})},e.fn.collapse.defaults={toggle:!0},e.fn.collapse.Constructor=t,e(function(){e("body").on("click.collapse.data-api","[data-toggle=collapse]",function(t){var i,n=e(this),s=n.attr("data-target")||t.preventDefault()||(i=n.attr("href"))&&i.replace(/.*(?=#[^\s]+$)/,""),r=e(s).data("collapse")?"toggle":n.data();e(s).collapse(r)})})}(window.jQuery),/* ============================================================
 * bootstrap-dropdown.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function(e){"use strict";function t(){e(i).parent().removeClass("open")}var i='[data-toggle="dropdown"]',n=function(t){var i=e(t).on("click.dropdown.data-api",this.toggle);e("html").on("click.dropdown.data-api",function(){i.parent().removeClass("open")})};n.prototype={constructor:n,toggle:function(){var i,n,s,r=e(this);if(!r.is(".disabled, :disabled"))return n=r.attr("data-target"),n||(n=r.attr("href"),n=n&&n.replace(/.*(?=#[^\s]*$)/,"")),i=e(n),i.length||(i=r.parent()),s=i.hasClass("open"),t(),s||i.toggleClass("open"),!1}},e.fn.dropdown=function(t){return this.each(function(){var i=e(this),s=i.data("dropdown");s||i.data("dropdown",s=new n(this)),"string"==typeof t&&s[t].call(i)})},e.fn.dropdown.Constructor=n,e(function(){e("html").on("click.dropdown.data-api",t),e("body").on("click.dropdown",".dropdown form",function(e){e.stopPropagation()}).on("click.dropdown.data-api",i,n.prototype.toggle)})}(window.jQuery),/* =========================================================
 * bootstrap-modal.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#modals
 * =========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */
!function(e){"use strict";function t(){var t=this,n=setTimeout(function(){t.$element.off(e.support.transition.end),i.call(t)},500);this.$element.one(e.support.transition.end,function(){clearTimeout(n),i.call(t)})}function i(){this.$element.hide().trigger("hidden"),n.call(this)}function n(t){var i=this.$element.hasClass("fade")?"fade":"";if(this.isShown&&this.options.backdrop){var n=e.support.transition&&i;this.$backdrop=e('<div class="modal-backdrop '+i+'" />').appendTo(document.body),"static"!=this.options.backdrop&&this.$backdrop.click(e.proxy(this.hide,this)),n&&this.$backdrop[0].offsetWidth,this.$backdrop.addClass("in"),n?this.$backdrop.one(e.support.transition.end,t):t()}else!this.isShown&&this.$backdrop?(this.$backdrop.removeClass("in"),e.support.transition&&this.$element.hasClass("fade")?this.$backdrop.one(e.support.transition.end,e.proxy(s,this)):s.call(this)):t&&t()}function s(){this.$backdrop.remove(),this.$backdrop=null}function r(){var t=this;this.isShown&&this.options.keyboard?e(document).on("keyup.dismiss.modal",function(e){27==e.which&&t.hide()}):this.isShown||e(document).off("keyup.dismiss.modal")}var o=function(t,i){this.options=i,this.$element=e(t).delegate('[data-dismiss="modal"]',"click.dismiss.modal",e.proxy(this.hide,this))};o.prototype={constructor:o,toggle:function(){return this[this.isShown?"hide":"show"]()},show:function(){var t=this,i=e.Event("show");this.$element.trigger(i),this.isShown||i.isDefaultPrevented()||(e("body").addClass("modal-open"),this.isShown=!0,r.call(this),n.call(this,function(){var i=e.support.transition&&t.$element.hasClass("fade");t.$element.parent().length||t.$element.appendTo(document.body),t.$element.show(),i&&t.$element[0].offsetWidth,t.$element.addClass("in"),i?t.$element.one(e.support.transition.end,function(){t.$element.trigger("shown")}):t.$element.trigger("shown")}))},hide:function(n){n&&n.preventDefault(),n=e.Event("hide"),this.$element.trigger(n),this.isShown&&!n.isDefaultPrevented()&&(this.isShown=!1,e("body").removeClass("modal-open"),r.call(this),this.$element.removeClass("in"),e.support.transition&&this.$element.hasClass("fade")?t.call(this):i.call(this))}},e.fn.modal=function(t){return this.each(function(){var i=e(this),n=i.data("modal"),s=e.extend({},e.fn.modal.defaults,i.data(),"object"==typeof t&&t);n||i.data("modal",n=new o(this,s)),"string"==typeof t?n[t]():s.show&&n.show()})},e.fn.modal.defaults={backdrop:!0,keyboard:!0,show:!0},e.fn.modal.Constructor=o,e(function(){e("body").on("click.modal.data-api",'[data-toggle="modal"]',function(t){var i,n=e(this),s=e(n.attr("data-target")||(i=n.attr("href"))&&i.replace(/.*(?=#[^\s]+$)/,"")),r=s.data("modal")?"toggle":e.extend({},s.data(),n.data());t.preventDefault(),s.modal(r)})})}(window.jQuery),/* ===========================================================
 * bootstrap-tooltip.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#tooltips
 * Inspired by the original jQuery.tipsy by Jason Frame
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */
!function(e){"use strict";var t=function(e,t){this.init("tooltip",e,t)};t.prototype={constructor:t,init:function(t,i,n){var s,r;this.type=t,this.$element=e(i),this.options=this.getOptions(n),this.enabled=!0,"manual"!=this.options.trigger&&(s="hover"==this.options.trigger?"mouseenter":"focus",r="hover"==this.options.trigger?"mouseleave":"blur",this.$element.on(s,this.options.selector,e.proxy(this.enter,this)),this.$element.on(r,this.options.selector,e.proxy(this.leave,this))),this.options.selector?this._options=e.extend({},this.options,{trigger:"manual",selector:""}):this.fixTitle()},getOptions:function(t){return t=e.extend({},e.fn[this.type].defaults,t,this.$element.data()),t.delay&&"number"==typeof t.delay&&(t.delay={show:t.delay,hide:t.delay}),t},enter:function(t){var i=e(t.currentTarget)[this.type](this._options).data(this.type);return i.options.delay&&i.options.delay.show?(clearTimeout(this.timeout),i.hoverState="in",this.timeout=setTimeout(function(){"in"==i.hoverState&&i.show()},i.options.delay.show),void 0):i.show()},leave:function(t){var i=e(t.currentTarget)[this.type](this._options).data(this.type);return i.options.delay&&i.options.delay.hide?(clearTimeout(this.timeout),i.hoverState="out",this.timeout=setTimeout(function(){"out"==i.hoverState&&i.hide()},i.options.delay.hide),void 0):i.hide()},show:function(){var e,t,i,n,s,r,o;if(this.hasContent()&&this.enabled){switch(e=this.tip(),this.setContent(),this.options.animation&&e.addClass("fade"),r="function"==typeof this.options.placement?this.options.placement.call(this,e[0],this.$element[0]):this.options.placement,t=/in/.test(r),e.remove().css({top:0,left:0,display:"block"}).appendTo(t?this.$element:document.body),i=this.getPosition(t),n=e[0].offsetWidth,s=e[0].offsetHeight,t?r.split(" ")[1]:r){case"bottom":o={top:i.top+i.height,left:i.left+i.width/2-n/2};break;case"top":o={top:i.top-s,left:i.left+i.width/2-n/2};break;case"left":o={top:i.top+i.height/2-s/2,left:i.left-n};break;case"right":o={top:i.top+i.height/2-s/2,left:i.left+i.width}}e.css(o).addClass(r).addClass("in")}},isHTML:function(e){return"string"!=typeof e||"<"===e.charAt(0)&&">"===e.charAt(e.length-1)&&e.length>=3||/^(?:[^<]*<[\w\W]+>[^>]*$)/.exec(e)},setContent:function(){var e=this.tip(),t=this.getTitle();e.find(".tooltip-inner")[this.isHTML(t)?"html":"text"](t),e.removeClass("fade in top bottom left right")},hide:function(){function t(){var t=setTimeout(function(){i.off(e.support.transition.end).remove()},500);i.one(e.support.transition.end,function(){clearTimeout(t),i.remove()})}var i=this.tip();i.removeClass("in"),e.support.transition&&this.$tip.hasClass("fade")?t():i.remove()},fixTitle:function(){var e=this.$element;(e.attr("title")||"string"!=typeof e.attr("data-original-title"))&&e.attr("data-original-title",e.attr("title")||"").removeAttr("title")},hasContent:function(){return this.getTitle()},getPosition:function(t){return e.extend({},t?{top:0,left:0}:this.$element.offset(),{width:this.$element[0].offsetWidth,height:this.$element[0].offsetHeight})},getTitle:function(){var e,t=this.$element,i=this.options;return e=t.attr("data-original-title")||("function"==typeof i.title?i.title.call(t[0]):i.title)},tip:function(){return this.$tip=this.$tip||e(this.options.template)},validate:function(){this.$element[0].parentNode||(this.hide(),this.$element=null,this.options=null)},enable:function(){this.enabled=!0},disable:function(){this.enabled=!1},toggleEnabled:function(){this.enabled=!this.enabled},toggle:function(){this[this.tip().hasClass("in")?"hide":"show"]()}},e.fn.tooltip=function(i){return this.each(function(){var n=e(this),s=n.data("tooltip"),r="object"==typeof i&&i;s||n.data("tooltip",s=new t(this,r)),"string"==typeof i&&s[i]()})},e.fn.tooltip.Constructor=t,e.fn.tooltip.defaults={animation:!0,placement:"top",selector:!1,template:'<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',trigger:"hover",title:"",delay:0}}(window.jQuery),/* ===========================================================
 * bootstrap-popover.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#popovers
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================== */
!function(e){"use strict";var t=function(e,t){this.init("popover",e,t)};t.prototype=e.extend({},e.fn.tooltip.Constructor.prototype,{constructor:t,setContent:function(){var e=this.tip(),t=this.getTitle(),i=this.getContent();e.find(".popover-title")[this.isHTML(t)?"html":"text"](t),e.find(".popover-content > *")[this.isHTML(i)?"html":"text"](i),e.removeClass("fade top bottom left right in")},hasContent:function(){return this.getTitle()||this.getContent()},getContent:function(){var e,t=this.$element,i=this.options;return e=t.attr("data-content")||("function"==typeof i.content?i.content.call(t[0]):i.content)},tip:function(){return this.$tip||(this.$tip=e(this.options.template)),this.$tip}}),e.fn.popover=function(i){return this.each(function(){var n=e(this),s=n.data("popover"),r="object"==typeof i&&i;s||n.data("popover",s=new t(this,r)),"string"==typeof i&&s[i]()})},e.fn.popover.Constructor=t,e.fn.popover.defaults=e.extend({},e.fn.tooltip.defaults,{placement:"right",content:"",template:'<div class="popover"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'})}(window.jQuery),/* =============================================================
 * bootstrap-scrollspy.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#scrollspy
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================== */
!function(e){"use strict";function t(t,i){var n,s=e.proxy(this.process,this),r=e(t).is("body")?e(window):e(t);this.options=e.extend({},e.fn.scrollspy.defaults,i),this.$scrollElement=r.on("scroll.scroll.data-api",s),this.selector=(this.options.target||(n=e(t).attr("href"))&&n.replace(/.*(?=#[^\s]+$)/,"")||"")+" .nav li > a",this.$body=e("body"),this.refresh(),this.process()}t.prototype={constructor:t,refresh:function(){var t,i=this;this.offsets=e([]),this.targets=e([]),t=this.$body.find(this.selector).map(function(){var t=e(this),i=t.data("target")||t.attr("href"),n=/^#\w/.test(i)&&e(i);return n&&i.length&&[[n.position().top,i]]||null}).sort(function(e,t){return e[0]-t[0]}).each(function(){i.offsets.push(this[0]),i.targets.push(this[1])})},process:function(){var e,t=this.$scrollElement.scrollTop()+this.options.offset,i=this.$scrollElement[0].scrollHeight||this.$body[0].scrollHeight,n=i-this.$scrollElement.height(),s=this.offsets,r=this.targets,o=this.activeTarget;if(t>=n)return o!=(e=r.last()[0])&&this.activate(e);for(e=s.length;e--;)o!=r[e]&&t>=s[e]&&(!s[e+1]||s[e+1]>=t)&&this.activate(r[e])},activate:function(t){var i,n;this.activeTarget=t,e(this.selector).parent(".active").removeClass("active"),n=this.selector+'[data-target="'+t+'"],'+this.selector+'[href="'+t+'"]',i=e(n).parent("li").addClass("active"),i.parent(".dropdown-menu")&&(i=i.closest("li.dropdown").addClass("active")),i.trigger("activate")}},e.fn.scrollspy=function(i){return this.each(function(){var n=e(this),s=n.data("scrollspy"),r="object"==typeof i&&i;s||n.data("scrollspy",s=new t(this,r)),"string"==typeof i&&s[i]()})},e.fn.scrollspy.Constructor=t,e.fn.scrollspy.defaults={offset:10},e(function(){e('[data-spy="scroll"]').each(function(){var t=e(this);t.scrollspy(t.data())})})}(window.jQuery),/* ========================================================
 * bootstrap-tab.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#tabs
 * ========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================== */
!function(e){"use strict";var t=function(t){this.element=e(t)};t.prototype={constructor:t,show:function(){var t,i,n,s=this.element,r=s.closest("ul:not(.dropdown-menu)"),o=s.attr("data-target");o||(o=s.attr("href"),o=o&&o.replace(/.*(?=#[^\s]*$)/,"")),s.parent("li").hasClass("active")||(t=r.find(".active a").last()[0],n=e.Event("show",{relatedTarget:t}),s.trigger(n),n.isDefaultPrevented()||(i=e(o),this.activate(s.parent("li"),r),this.activate(i,i.parent(),function(){s.trigger({type:"shown",relatedTarget:t})})))},activate:function(t,i,n){function s(){r.removeClass("active").find("> .dropdown-menu > .active").removeClass("active"),t.addClass("active"),o?(t[0].offsetWidth,t.addClass("in")):t.removeClass("fade"),t.parent(".dropdown-menu")&&t.closest("li.dropdown").addClass("active"),n&&n()}var r=i.find("> .active"),o=n&&e.support.transition&&r.hasClass("fade");o?r.one(e.support.transition.end,s):s(),r.removeClass("in")}},e.fn.tab=function(i){return this.each(function(){var n=e(this),s=n.data("tab");s||n.data("tab",s=new t(this)),"string"==typeof i&&s[i]()})},e.fn.tab.Constructor=t,e(function(){e("body").on("click.tab.data-api",'[data-toggle="tab"], [data-toggle="pill"]',function(t){t.preventDefault(),e(this).tab("show")})})}(window.jQuery),/* =============================================================
 * bootstrap-typeahead.js v2.0.3
 * http://twitter.github.com/bootstrap/javascript.html#typeahead
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */
!function(e){"use strict";var t=function(t,i){this.$element=e(t),this.options=e.extend({},e.fn.typeahead.defaults,i),this.matcher=this.options.matcher||this.matcher,this.sorter=this.options.sorter||this.sorter,this.highlighter=this.options.highlighter||this.highlighter,this.updater=this.options.updater||this.updater,this.$menu=e(this.options.menu).appendTo("body"),this.source=this.options.source,this.shown=!1,this.listen()};t.prototype={constructor:t,select:function(){var e=this.$menu.find(".active").attr("data-value");return this.$element.val(this.updater(e)).change(),this.hide()},updater:function(e){return e},show:function(){var t=e.extend({},this.$element.offset(),{height:this.$element[0].offsetHeight});return this.$menu.css({top:t.top+t.height,left:t.left}),this.$menu.show(),this.shown=!0,this},hide:function(){return this.$menu.hide(),this.shown=!1,this},lookup:function(){var t,i=this;return this.query=this.$element.val(),this.query?(t=e.grep(this.source,function(e){return i.matcher(e)}),t=this.sorter(t),t.length?this.render(t.slice(0,this.options.items)).show():this.shown?this.hide():this):this.shown?this.hide():this},matcher:function(e){return~e.toLowerCase().indexOf(this.query.toLowerCase())},sorter:function(e){for(var t,i=[],n=[],s=[];t=e.shift();)t.toLowerCase().indexOf(this.query.toLowerCase())?~t.indexOf(this.query)?n.push(t):s.push(t):i.push(t);return i.concat(n,s)},highlighter:function(e){var t=this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g,"\\$&");return e.replace(new RegExp("("+t+")","ig"),function(e,t){return"<strong>"+t+"</strong>"})},render:function(t){var i=this;return t=e(t).map(function(t,n){return t=e(i.options.item).attr("data-value",n),t.find("a").html(i.highlighter(n)),t[0]}),t.first().addClass("active"),this.$menu.html(t),this},next:function(){var t=this.$menu.find(".active").removeClass("active"),i=t.next();i.length||(i=e(this.$menu.find("li")[0])),i.addClass("active")},prev:function(){var e=this.$menu.find(".active").removeClass("active"),t=e.prev();t.length||(t=this.$menu.find("li").last()),t.addClass("active")},listen:function(){this.$element.on("blur",e.proxy(this.blur,this)).on("keypress",e.proxy(this.keypress,this)).on("keyup",e.proxy(this.keyup,this)),(e.browser.webkit||e.browser.msie)&&this.$element.on("keydown",e.proxy(this.keypress,this)),this.$menu.on("click",e.proxy(this.click,this)).on("mouseenter","li",e.proxy(this.mouseenter,this))},keyup:function(e){switch(e.keyCode){case 40:case 38:break;case 9:case 13:if(!this.shown)return;this.select();break;case 27:if(!this.shown)return;this.hide();break;default:this.lookup()}e.stopPropagation(),e.preventDefault()},keypress:function(e){if(this.shown){switch(e.keyCode){case 9:case 13:case 27:e.preventDefault();break;case 38:if("keydown"!=e.type)break;e.preventDefault(),this.prev();break;case 40:if("keydown"!=e.type)break;e.preventDefault(),this.next()}e.stopPropagation()}},blur:function(){var e=this;setTimeout(function(){e.hide()},150)},click:function(e){e.stopPropagation(),e.preventDefault(),this.select()},mouseenter:function(t){this.$menu.find(".active").removeClass("active"),e(t.currentTarget).addClass("active")}},e.fn.typeahead=function(i){return this.each(function(){var n=e(this),s=n.data("typeahead"),r="object"==typeof i&&i;s||n.data("typeahead",s=new t(this,r)),"string"==typeof i&&s[i]()})},e.fn.typeahead.defaults={source:[],items:8,menu:'<ul class="typeahead dropdown-menu"></ul>',item:'<li><a href="#"></a></li>'},e.fn.typeahead.Constructor=t,e(function(){e("body").on("focus.typeahead.data-api",'[data-provide="typeahead"]',function(t){var i=e(this);i.data("typeahead")||(t.preventDefault(),i.typeahead(i.data()))})})}(window.jQuery);