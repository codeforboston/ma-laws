Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $
View = require './view'
Pouch = require 'pouchdb'
spin = require 'spin'
require 'bootstrap'

class Routes extends Backbone.Router
	initialize:(opts)->
		@body = opts.body
	routes:
		'c:type':'nStyle'
		'y:type':'session'
		'SessionLaw':'years'
		'SessionLaw/Year:year':'years'
		':type': 'roo'
		':type/Part:part': 'roo'
		':type/Part:part/Title:title': 'roo'
		':type/Part:part/Title:title/Chapter:chapter': 'roo'
		':type/Part:part/Title:title/Chapter:chapter/Section:section': 'roo'
		'q/:query':'qoo'
		'*spat':'roo'
	roo:(type='home',part='all',title='all',chapter='all',section='all')->
		@body.spin()
		parts = 
			type:type
			part:part
			title:title
			chapter:chapter
			section:section
		parts.chapter = parseInt(parts.chapter,10) unless parts.chapter is 'all'
		parts.section = parseInt(parts.section,10) unless parts.section is 'all'
		@body.render parts
	qoo:(query)->
		@body.spin()
		@body.render {q:query}
	nStyle:(path)->
		@body.spin()
		if 's' in path
			split = path.split('s')
			parts=
				newStyleName:true
				c:split[0]
				s:split[1]
			@body.render parts
		else if 'a' in path
			split = path.split('a')
			parts=
				c:split[0]
				a:split[1]
			@body.render parts
	session:(path)->
		@body.spin()
		if 'c' in path
			split = path.split('c')
			parts = 
				y:split[0]
				c:split[1]
			@body.render parts
	years:(year='all')->
		@body.spin()
		@body.render
			type:'session'
			year:year



start = (dbname)=>
		Pouch "#{location.protocol}//#{location.host}//law",(err,db)->
			window.body = new View
				db:db
				el:$ '#mainContent'
			window.routes = new Routes
				body:window.body
			Backbone.history.start
				pushState: true
				hashChange: false
				root:'/law/_design/laws/_rewrite/'
			true
			$('#searchForm').on 'submit', (e)->
				e.preventDefault()
				routes.navigate 'q/'+$('#searchBox').val(),
					trigger:true
			$('.menulinks').on 'click', (a)->
				a.preventDefault()
				routes.navigate a.target.id,
					trigger:true
start('law')
