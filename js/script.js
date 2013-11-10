var Backbone = require('backbone');

var $ = require('jquery');

Backbone.$ = $;

var View = require('./view');

var Pouch = require('./pouchdb/src/pouch.js');

var spin = require('spin');

require('bootstrap');

var Routes = Backbone.Router.extend({
  initialize : function(opts) {
      this.body = opts.body;
    },
    routes : {
      'c:type': 'nStyle',
      'y:type': 'session',
      'SessionLaw': 'years',
      'SessionLaw/Year:year': 'years',
      ':type': 'roo',
      ':type/Part:part': 'roo',
      ':type/Part:part/Title:title': 'roo',
      ':type/Part:part/Title:title/Chapter:chapter': 'roo',
      ':type/Part:part/Title:title/Chapter:chapter/Section:section': 'roo',
      'q/:query': 'qoo',
      '*spat': 'roo'
    },
    roo : function(type, part, title, chapter, section) {
      var parts;
      if (type == null) {
        type = 'home';
      }
      if (part == null) {
        part = 'all';
      }
      if (title == null) {
        title = 'all';
      }
      if (chapter == null) {
        chapter = 'all';
      }
      if (section == null) {
        section = 'all';
      }
      this.body.spin();
      parts = {
        type: type,
        part: part,
        title: title,
        chapter: chapter,
        section: section
      };
      if (parts.chapter !== 'all') {
        parts.chapter = parseInt(parts.chapter, 10);
      }
      if (parts.section !== 'all') {
        parts.section = parseInt(parts.section, 10);
      }
      this.body.render(parts);
    },
    qoo : function(query) {
      this.body.spin();
      this.body.render({
        q: query
      });
    },

  nStyle : function(path) {
      var parts, split;
      this.body.spin();
      if (path.indexOf('s') >= 0) {
        split = path.split('s');
        parts = {
          newStyleName: true,
          c: split[0],
          s: split[1]
        };
        this.body.render(parts);
      } else if (path.indexOf('a') >= 0) {
        split = path.split('a');
        parts = {
          c: split[0],
          a: split[1]
        };
        this.body.render(parts);
      }
    },
session : function(path) {
      var parts, split;
      this.body.spin();
      if (path.indexOf('c') >= 0) {
        split = path.split('c');
        parts = {
          y: split[0],
          c: split[1]
        };
        this.body.render(parts);
      }
    },

    years : function(year) {
      if (year == null) {
        year = 'all';
      }
      this.body.spin();
      this.body.render({
        type: 'session',
        year: year
      });
    }
  });

  function start(dbname) {
    Pouch(location.protocol + "//" + location.host + "/ltest", function(err, db) {
      window.body = new View({
        db: db,
        el: $('#mainContent')
      });
      window.routes = new Routes({
        body: window.body
      });
      Backbone.history.start({
        pushState: true,
        hashChange: false,
       //root: '/law/_design/laws/_rewrite/'
      });
      $('#searchForm').on('submit', function(e) {
        e.preventDefault();
        routes.navigate('q/' + $('#searchBox').val(), {
          trigger: true
        });
      });
      $('.menulinks').on('click', function(a) {
        a.preventDefault();
        routes.navigate(a.target.id, {
          trigger: true
        });
      });
    });
  };

  start('law');