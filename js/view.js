var Backbone = require('backbone');

var $ = require('jquery');

Backbone.$ = $;

var templates = require('../templates');

var spin = require('spin');
var Breadcrumb = require('./breadcrumb');
var denodify = require('lie-denodify');
var View = Backbone.View.extend({
    initialize : function(opts) {
      return this.db = opts.db;
    },
    root:(location.port === "5984"||location.hostname === '127.0.0.1')?'/law/_design/laws/_rewrite/':'/',
    breadcrumb:new Breadcrumb({ el: $('#bcrumb')}),
    events : {
      'click .bodyLink': 'movePage'
    },
    search : function(q) {
      if(!this.dbSearch){
        this.dbSearch = denodify(this.db.search);
      }
      return this.dbSearch('laws/sections',{
        q:q,
        include_docs:true,
        limit:200
      });
    },
    movePage : function(a) {
      a.preventDefault();
      return window.routes.navigate(a.target.id, {
        trigger: true
      });
    },
    spin : function(a) {
      return this.$el.spin(a);
    },
    template : templates,
    render : function(loc) {
      var root = this.root;
      if(!this.fetch){
        this.fetch=denodify(this.db.get);
      }
      if(!this.query){
        this.query = denodify(this.db.query);
      }
      var id, opts, type;
      function stopSpin(){
        body.spin(false);
      }
      if ('q' in loc) {
        return this.search(loc.q).then(function(resp) {
          resp.q = loc.q;
          resp.root = root;
          stopSpin();
          return body.$el.html(body.template.search(resp));
        });
      } else if ('newStyleName' in loc) {
        id = "c" + loc.c + "s" + loc.s;
        return this.fetch(id).then(function(doc) {
            stopSpin();
            body.breadcrumb.render(doc);
            doc.root = root;
            return body.$el.html(body.template.section(doc));
        },stopSpin);
      } else if ('a' in loc) {
        id = "c" + loc.c + "a" + loc.a;
        return this.fetch(id).then(function(doc) {
            stopSpin();
            body.breadcrumb.render(doc);
            doc.root = root;
            return body.$el.html(body.template.article(doc));
        },stopSpin);
      } else if ('y' in loc) {
        id = "y" + loc.y + "c" + loc.c;
        return this.fetch(id).then(function(doc) {
            stopSpin();
            body.breadcrumb.render({
                type:'Session',
                year:doc.year,
                ychapter:doc.chapter
            });
            doc.root = root;
            return body.$el.html(body.template.session(doc));
        },stopSpin);
      } else if (loc.type && loc.type === 'session') {
        if (loc.year === 'all') {
          opts = {
            startkey: [loc.type],
            endkey: [loc.type, {}],
            group_level: 2
          };
          return this.query("laws/sessions", opts).then(function(resp) {
            resp.rows = resp.rows.map(function(row) {
              var out;
              out = {};
              out.year = row.key.pop();
              return out;
            });
            body.breadcrumb.render({
                type:'Session'
            });
            opts.include_docs=true;
            opts.reduce=false;
            delete opts.group_level;
            resp.raw = $.param(opts);
            stopSpin();
            resp.root = root;
            return body.$el.html(body.template.sess(resp));
          });
        } else {
          opts = {
            startkey: [loc.type, parseInt(loc.year, 10)],
            endkey: [loc.type, parseInt(loc.year, 10), {}],
            reduce: false,
            include_docs: true
          };
          return this.query("laws/sessions", opts).then(function(resp) {
            resp.rows.sort(function(a, b) {
              return a.doc.chapter - b.doc.chapter;
            });
            resp.year = loc.year;
            body.breadcrumb.render({
                type:'Session',
                year:loc.year
            });
            body.spin(false);
            resp.root = root;
            return body.$el.html(body.template.year(resp));
          },stopSpin);
        }
      } else if (loc.section !== 'all') {
        id = "c" + loc.chapter + "s" + loc.section;
        return this.fetch(id).then(function(doc) {
            stopSpin();
            body.breadcrumb.render(doc);
            doc.root = root;
            return body.$el.html(body.template.section(doc));
        },stopSpin);
      } else if (loc.section === 'all' && loc.chapter !== 'all') {
        if (loc.type = 'GeneralLaws') {
          type = 'general';
        } else {
          type = loc.type;
        }
        opts = {
          startkey: [type, loc.part, loc.title, loc.chapter.toString()],
          endkey: [type, loc.part, loc.title, loc.chapter.toString(), {}],
          reduce: false,
          include_docs: true
        };
        return this.query("laws/all", opts).then(function(resp) {
          resp.rows = resp.rows.map(function(item) {
            if (item.doc.section) {
              item.doc.sub = item.doc.section;
              item.doc.shortCode = "s";
              item.doc.longCode = "Section";
            } else if (item.doc.article) {
              item.doc.sub = item.doc.article;
              item.doc.shortCode = "a";
              item.doc.longCode = "Article";
            }
            return item;
          });
          body.spin(false);
          body.breadcrumb.render({
            type:'General',
            chapter:loc.chapter,
            title:loc.title,
            part:loc.part
          });
          resp.chapter = loc.chapter;
          resp.root = root;
          return body.$el.html(body.template.chapter(resp));
        });
      } else if (loc.chapter === 'all' && loc.title !== 'all') {
        if (loc.type = 'GeneralLaws') {
          type = 'general';
        } else {
          type = loc.type;
        }
        opts = {
          startkey: [type, loc.part, loc.title],
          endkey: [type, loc.part, loc.title, {}],
          group_level: 4
        };
        return this.query("laws/all", opts).then(function(resp) {
          var rows = resp.rows.map(function(row) {
            var out = {};
            out.chapter = row.key.pop();
            out.title = row.key.pop();
            out.part = row.key.pop();
            return out;
          });
          body.spin(false);
          body.breadcrumb.render({
            title: loc.title,
            part: loc.part,
            type:'General'
          });
          return body.$el.html(body.template.title({
            rows: rows,
            title: loc.title,
            part: loc.part,
            root:root
          }));
        });
      } else if (loc.title === 'all' && loc.part !== 'all') {
        if (loc.type = 'GeneralLaws') {
          type = 'general';
        } else {
          type = loc.type;
        }
        opts = {
          startkey: [type, loc.part],
          endkey: [type, loc.part, {}],
          group_level: 3
        };
        return this.query("laws/all", opts).then(function(resp) {
          var rows;
          rows = resp.rows.map(function(row) {
            var out;
            out = {};
            out.title = row.key.pop();
            out.part = row.key.pop();
            return out;
          });
          body.spin(false);
          body.breadcrumb.render({
            part: loc.part,
            type:'General'
          });
          return body.$el.html(body.template.part({
            rows: rows,
            part: loc.part,
            root:root
          }));
        });
      } else {
        type = 'general';
        opts = {
          startkey: [type],
          endkey: [type, {}],
          group_level: 2
        };
        return this.query("laws/all", opts).then(function(resp) {
          var rows;
          rows = resp.rows.map(function(row) {
            var out;
            out = {};
            out.part = row.key.pop();
            return out;
          });
          body.spin(false);
          body.breadcrumb.render({
            type:'General'
          });
          opts.include_docs=true;
          opts.reduce=false;
          delete opts.group_level;
          return body.$el.html(body.template.general({
            rows: rows,
            raw: $.param(opts),
            root:root
          }));
        });
      }
    }

  });

  module.exports = View;
