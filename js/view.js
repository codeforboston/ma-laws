var Backbone = require('backbone');

var $ = require('jquery');

Backbone.$ = $;

var templates = require('../templates');

var spin = require('spin');

var View = Backbone.View.extend({
    initialize : function(opts) {
      return this.db = opts.db;
    },
    events : {
      'click .bodyLink': 'movePage'
    },
    search : function(q) {
      var opts, path;
      path = "" + (db.id()) + "_design/laws/_search/sections";
      opts = {
        q: q,
        include_docs: true,
        limit: 200
      };
      return $.ajax(path, {
        data: opts,
        dataType: 'json'
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
      var id, opts, type;
      if ('q' in loc) {
        return this.search(loc.q).then(function(resp) {
          console.log(resp);
          resp.q = loc.q;
          body.spin(false);
          return body.$el.html(body.template.search(resp));
        });
      } else if ('newStyleName' in loc) {
        id = "c" + loc.c + "s" + loc.s;
        return this.db.get(id, function(err, doc) {
          if (err) {
            body.spin(false);
          } else {
            body.spin(false);
            return body.$el.html(body.template.section(doc));
          }
        });
      } else if ('a' in loc) {
        id = "c" + loc.c + "a" + loc.a;
        return this.db.get(id, function(err, doc) {
          if (err) {
            body.spin(false);
          } else {
            body.spin(false);
            return body.$el.html(body.template.article(doc));
          }
        });
      } else if ('y' in loc) {
        id = "y" + loc.y + "c" + loc.c;
        return this.db.get(id, function(err, doc) {
          if (err) {
            body.spin(false);
          } else {
            body.spin(false);
            return body.$el.html(body.template.session(doc));
          }
        });
      } else if (loc.type && loc.type === 'session') {
        if (loc.year === 'all') {
          opts = {
            startkey: [loc.type],
            endkey: [loc.type, {}],
            group_level: 2
          };
          return this.db.query("laws/sessions", opts, function(err, resp) {
            resp.rows = resp.rows.map(function(row) {
              var out;
              out = {};
              out.year = row.key.pop();
              return out;
            });
            body.spin(false);
            return body.$el.html(body.template.sess(resp));
          });
        } else {
          opts = {
            startkey: [loc.type, parseInt(loc.year, 10)],
            endkey: [loc.type, parseInt(loc.year, 10), {}],
            reduce: false,
            include_docs: true
          };
          return this.db.query("laws/sessions", opts, function(err, resp) {
            resp.rows.sort(function(a, b) {
              return a.doc.chapter - b.doc.chapter;
            });
            resp.year = loc.year;
            body.spin(false);
            return body.$el.html(body.template.year(resp));
          });
        }
      } else if (loc.section !== 'all') {
        id = "c" + loc.chapter + "s" + loc.section;
        return this.db.get(id, function(err, doc) {
          if (err) {
            body.spin(false);
          } else {
            body.spin(false);
            return body.$el.html(body.template.section(doc));
          }
        });
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
        return this.db.query("laws/all", opts, function(err, resp) {
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
          resp.chap = loc.chapter;
          resp.tit = loc.title;
          resp.pat = loc.part;
          body.spin(false);
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
        return this.db.query("laws/all", opts, function(err, resp) {
          var rows;
          rows = resp.rows.map(function(row) {
            var out;
            out = {};
            out.chapter = row.key.pop();
            out.title = row.key.pop();
            out.part = row.key.pop();
            return out;
          });
          body.spin(false);
          return body.$el.html(body.template.title({
            row: rows,
            t: loc.title,
            tp: loc.part
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
        return this.db.query("laws/all", opts, function(err, resp) {
          var rows;
          rows = resp.rows.map(function(row) {
            var out;
            out = {};
            out.title = row.key.pop();
            out.part = row.key.pop();
            return out;
          });
          body.spin(false);
          return body.$el.html(body.template.part({
            rowp: rows,
            p: loc.part
          }));
        });
      } else {
        type = 'general';
        opts = {
          startkey: [type],
          endkey: [type, {}],
          group_level: 2
        };
        return this.db.query("laws/all", opts, function(err, resp) {
          var rows;
          rows = resp.rows.map(function(row) {
            var out;
            out = {};
            out.part = row.key.pop();
            return out;
          });
          body.spin(false);
          return body.$el.html(body.template.general({
            rowg: rows,
            g: true
          }));
        });
      }
    }

  });

  module.exports = View;
