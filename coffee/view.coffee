Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $
templates = require './templates'
spin = require 'spin'

class View extends Backbone.View
	initialize:(opts)->
		@db = opts.db
	events:
		'click .bodyLink': 'movePage'
	search:(q)->
		path = "#{db.id()}_design/laws/_search/sections"
		opts = 
			q:q
			include_docs:true
			limit:200
		$.ajax path,
			data:opts
			dataType:'json'
	movePage:(a)->
		a.preventDefault()
		window.routes.navigate a.target.id,
			trigger:true
	spin:(a)->
		@$el.spin(a)
	template:templates
	render:(loc)->
		#console.log(loc)
		if 'q' of loc
			@search(loc.q).then (resp)->
				console.log resp
				resp.q=loc.q
				body.spin(false)
				body.$el.html(body.template.search(resp))
		else if 'newStyleName' of loc
			id = """c#{loc.c}s#{loc.s}"""
			@db.get id,(err,doc)->
				if err
					body.spin(false)
					return
				else
					body.spin(false)
					body.$el.html(body.template.section(doc))
		else if 'a' of loc
			id = """c#{loc.c}a#{loc.a}"""
			@db.get id,(err,doc)->
				if err
					body.spin(false)
					return
				else
					body.spin(false)
					body.$el.html(body.template.article(doc))
		else if 'y' of loc
			id = """y#{loc.y}c#{loc.c}"""
			@db.get id,(err,doc)->
				if err
					body.spin(false)
					return
				else
					body.spin(false)
					body.$el.html(body.template.session(doc))
		else if loc.type and loc.type == 'session'
			if loc.year=='all'
				opts=
					startkey:[loc.type]
					endkey:[loc.type,{}]
					group_level:2
				@db.query """laws/sessions""",opts,(err,resp)->
					resp.rows = resp.rows.map (row)->
						out = {}
						out.year= row.key.pop()
						out
					body.spin(false)
					body.$el.html(body.template.sess(resp))
			else
				opts=
					startkey:[loc.type,parseInt(loc.year,10)]
					endkey:[loc.type,parseInt(loc.year,10),{}]
					reduce:false
					include_docs:true
				@db.query """laws/sessions""",opts,(err,resp)->
					resp.rows.sort (a,b)->
						a.doc.chapter-b.doc.chapter
					resp.year = loc.year
					body.spin(false)
					body.$el.html(body.template.year(resp))
		else if loc.section isnt 'all'
			id = """c#{loc.chapter}s#{loc.section}"""
			@db.get id,(err,doc)->
				if err
					body.spin(false)
					return
				else
					body.spin(false)
					body.$el.html(body.template.section(doc))
		else if loc.section is 'all' and loc.chapter isnt 'all'
			if loc.type = 'GeneralLaws'
				type = 'general'
			else
				type = loc.type
			opts=
				startkey:[type,loc.part,loc.title,loc.chapter.toString()]
				endkey:[type,loc.part,loc.title,loc.chapter.toString(),{}]
				reduce:false
				include_docs:true
			@db.query """laws/all""",opts,(err,resp)->
				resp.rows = resp.rows.map (item)->
					if item.doc.section
						item.doc.sub = item.doc.section
						item.doc.shortCode = "s"
						item.doc.longCode = "Section"
					else if item.doc.article
						item.doc.sub = item.doc.article
						item.doc.shortCode = "a"
						item.doc.longCode = "Article"
					item
				resp.chap = loc.chapter
				resp.tit=loc.title
				resp.pat = loc.part
				#console.log resp
				body.spin(false)
				body.$el.html(body.template.chapter(resp))
		else if loc.chapter is 'all' and loc.title isnt 'all'
			if loc.type = 'GeneralLaws'
				type = 'general'
			else
				type = loc.type
			opts=
				startkey:[type,loc.part,loc.title]
				endkey:[type,loc.part,loc.title,{}]
				group_level:4
			@db.query """laws/all""",opts,(err,resp)->
				rows = resp.rows.map (row)->
					out = {}
					out.chapter = row.key.pop()
					out.title= row.key.pop()
					out.part = row.key.pop()
					out
				body.spin(false)
				body.$el.html(body.template.title({row:rows,t:loc.title,tp:loc.part}))
		else if loc.title is 'all' and loc.part isnt 'all'
			if loc.type = 'GeneralLaws'
				type = 'general'
			else
				type = loc.type
			opts=
				startkey:[type,loc.part]
				endkey:[type,loc.part,{}]
				group_level:3
			@db.query """laws/all""",opts,(err,resp)->
				rows = resp.rows.map (row)->
					out = {}
					out.title = row.key.pop()
					out.part= row.key.pop()
					out
				body.spin(false)
				body.$el.html(body.template.part({rowp:rows,p:loc.part}))
		else
			type = 'general'
			opts=
				startkey:[type]
				endkey:[type,{}]
				group_level:2
			@db.query """laws/all""",opts,(err,resp)->
				rows = resp.rows.map (row)->
					out = {}
					out.part= row.key.pop()
					out
				body.spin(false)
				body.$el.html(body.template.general({rowg:rows,g:true}))
module.exports = View
