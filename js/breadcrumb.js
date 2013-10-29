var Backbone = require('backbone');

var $ = require('jquery');

Backbone.$ = $;

var template = require('../templates/breadcrumb.hbs');

module.exports = Backbone.View.extend({
    template:template,
    render:function(doc){
        this.$el.html(this.template(doc))
    },
    events : {
      'click .bodyLink': 'movePage'
    },
    movePage : function(a) {
      a.preventDefault();
      return window.routes.navigate(a.target.id, {
        trigger: true
      });
    }
});
