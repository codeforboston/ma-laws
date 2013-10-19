db = false

class View extends Backbone.View
	initialize:()->
		@render = @options.render
		@routes = @options.routes
		true
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
		routes.navigate a.target.id,
			trigger:true
	spin:(a)->
		@$el.spin(a)
	template:
		search:Mustache.compile """
		<div class="row">
		<h1>"{{q}}"</h1>
		<p>{{total_rows}} results</p><dl>
		{{#rows}}
		{{#doc.section}}<dt>
		<a class='bodyLink' href='/c{{doc.chapter}}s{{doc.section}}' id="/c{{doc.chapter}}s{{doc.section}}">Chapter {{doc.chapter}} Section {{doc.section}}</a>
  		</dt>
		{{#doc.desc}}<dd><strong>{{doc.desc}}</strong></dd>{{/doc.desc}}
		{{#doc.text}}<dd>{{doc.text}}</dd>{{/doc.text}}
		{{/doc.section}}
		{{#doc.article}}<dt>
		<a class='bodyLink' href='/c{{doc.chapter}}a{{doc.article}}' id="/c{{doc.chapter}}a{{doc.article}}">Chapter {{doc.chapter}} Article {{doc.article}}</a>
  		</dt>
		{{#doc.desc}}<dd><strong>{{doc.desc}}</strong></dd>{{/doc.desc}}
		{{#doc.text}}<dd>{{doc.text}}</dd>{{/doc.text}}
		{{/doc.article}}
		{{#doc.year}}<dt>
		<a class='bodyLink' href='../y{{doc.year}}c{{doc.chapter}}' id="/y{{doc.year}}c{{doc.chapter}}">Session {{doc.year}} Chapter {{doc.chapter}}</a>
  		</dt>
		{{#doc.desc}}<dd>{{doc.desc}}</dd>{{/doc.desc}}
		{{/doc.year}}
		{{/rows}}
		</dl>
		</div>
		"""
		section:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			<li><a class='bodyLink' href='GeneralLaws/Part{{part}}' id="/GeneralLaws/Part{{part}}">Part {{part}}</a></li>
  			<li><a class='bodyLink' href='GeneralLaws/Part{{part}}/Title{{title}}' id="/GeneralLaws/Part{{part}}/Title{{title}}">Title {{title}}</a></li>
  			<li><a class='bodyLink' href='GeneralLaws/Part{{part}}/Title{{title}}/Chapter{{chapter}}' id="/GeneralLaws/Part{{part}}/Title{{title}}/Chapter{{chapter}}">Chapter {{chapter}}</a></li>
  			<li class="active">Section {{section}}</li>
		</ul>
		<h1>Chapter {{chapter}} Section {{section}}</h1>
		{{#desc}}<h2>{{desc}}</h2>{{/desc}}
		{{#text}}<p>{{text}}</p>{{/text}}
		</div>
		"""
		article:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			<li><a class='bodyLink' href='GeneralLaws/Part{{part}}' id="/GeneralLaws/Part{{part}}">Part {{part}}</a></li>
  			<li><a class='bodyLink' href='GeneralLaws/Part{{part}}/Title{{title}}' id="/GeneralLaws/Part{{part}}/Title{{title}}">Title {{title}}</a></li>
  			<li><a class='bodyLink' href='GeneralLaws/Part{{part}}/Title{{title}}/Chapter{{chapter}}' id="/GeneralLaws/Part{{part}}/Title{{title}}/Chapter{{chapter}}">Chapter {{chapter}}</a></li>
  			<li class="active">Article {{article}}</li>
		</ul>
		<h1>Chapter {{chapter}} Article {{article}}</h1>
		{{#desc}}<h2>{{desc}}</h2>{{/desc}}
		{{#text}}<p>{{text}}</p>{{/text}}
		</div>
		"""
		session:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="SessionLaw" id="SessionLaw">Session Laws</a></li>
  			<li><a class='bodyLink' href="SessionLaw/Year{{year}}" id="SessionLaw/Year{{year}}">Year {{year}}</a></li>
  			
  			<li class="active">Chapter {{chapter}}</li>
		</ul>
		<h1>Session {{year}} Chapter {{chapter}}</h1>
		{{#desc}}<h4>{{desc}}</h4>{{/desc}}
		{{#text}}{{{text}}}{{/text}}
		</div>
		"""
		chapter:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="/GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			<li><a class='bodyLink' href='/GeneralLaws/Part{{doc.part}}' id="GeneralLaws/Part{{pat}}">Part {{pat}}</a></li>
  			<li><a class='bodyLink' href='/GeneralLaws/Part{{doc.part}}/Title{{doc.title}}' id="GeneralLaws/Part{{pat}}/Title{{tit}}">Title {{tit}}</a></li>
  			<li class="active">Chapter {{chap}}</li>
		</ul>
		<h1>Chapter {{chap}}</h1>
		<dl>
		{{#rows}}
		{{#doc.desc}}<dt><strong>{{doc.longCode}} {{doc.sub}}:</strong> <a class='bodyLink' href='../../../c{{doc.chapter}}{{doc.shortCode}}{{doc.sub}}' id='c{{doc.chapter}}{{doc.shortCode}}{{doc.sub}}'>{{doc.desc}}</a></dt>{{/doc.desc}}
		{{#doc.text}}<dd>{{doc.text}}</dd>{{/doc.text}}
		{{/rows}}
		</dl>
		</div>
		"""
		title:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="/GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			<li><a class='bodyLink' href='/GeneralLaws/Part{{tp}}' id="/GeneralLaws/Part{{tp}}">Part {{tp}}</a></li>
  			
  			<li class="active">Title {{t}}</li>
		</ul>
		<h1>Title {{t}}</h1>
		<ul>
		{{#row}}
			<li>
			<a class='bodyLink' href='Title{{title}}/Chapter{{chapter}}' id="GeneralLaws/Part{{part}}/Title{{title}}/Chapter{{chapter}}">
				Chapter {{chapter}}
			</a>
			</li>
		{{/row}}
		</ul>
		</div>
		"""
		year:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="/SessionLaw" id="SessionLaw">Session Laws</a></li>
  			
  			
  			<li class="active">Year {{year}}</li>
		</ul>
		<h1>Year {{year}}</h1>
		<ul>
		{{#rows}}{{#doc.desc}}
			<li><h3>
			<a class='bodyLink' href='/{{doc._id}}' id="{{doc._id}}">
				Chapter {{doc.chapter}}
			</a></h3>
			{{doc.desc}}
			</li>
			{{/doc.desc}}
		{{/rows}}
		</ul>
		</div>
		"""
		part:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="/GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			
  			
  			<li class="active">Part {{p}}</li>
		</ul>
		<h1>Part {{p}}</h1>
		<ul>
		{{#rowp}}
			<li>
			<a class='bodyLink' href='Part{{part}}/Title{{title}}' id="GeneralLaws/Part{{part}}/Title{{title}}">
				Title {{title}}
			</a>
			</li>
		{{/rowp}}
		</ul>
		</div>
		"""
		sess:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li class="active">Session Laws</li>
		</ul>
		<h1>Session Laws</h1>
		<ul>
		{{#rows}}
			<li>
			<a class='bodyLink' href='SessionLaw/Year{{year}}' id="SessionLaw/Year{{year}}">
				Year {{year}}
			</a>
			</li>
		{{/rows}}
		</ul>
		</div>
	"""
		general:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li class="active">General Laws</li>
		</ul>
		<h1>General Laws</h1>
		<ul>
		{{#rowg}}
			<li>
			<a class='bodyLink' href='GeneralLaws/Part{{part}}' id="GeneralLaws/Part{{part}}">
				Part {{part}}
			</a>
			</li>
		{{/rowg}}
		</ul>
		</div>
	"""

body = new View
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
			db.get id,(err,doc)->
				if err
					body.spin(false)
					return
				else
					body.spin(false)
					body.$el.html(body.template.section(doc))
		else if 'a' of loc
			id = """c#{loc.c}a#{loc.a}"""
			db.get id,(err,doc)->
				if err
					body.spin(false)
					return
				else
					body.spin(false)
					body.$el.html(body.template.article(doc))
		else if 'y' of loc
			id = """y#{loc.y}c#{loc.c}"""
			db.get id,(err,doc)->
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
				db.query """laws/sessions""",opts,(err,resp)->
					resp.rows = resp.rows.map (row)->
						out = {}
						out.year= row.key.pop()
						out
					body.spin(false)
					body.$el.html(body.template.sess(resp))
			else
				opts=
					startkey:[loc.type,loc.year]
					endkey:[loc.type,loc.year,{}]
					reduce:false
					include_docs:true
				db.query """laws/sessions""",opts,(err,resp)->
					resp.rows.sort (a,b)->
						a.doc.chapter-b.doc.chapter
					resp.year = loc.year
					body.spin(false)
					body.$el.html(body.template.year(resp))
		else if loc.section isnt 'all'
			id = """c#{loc.chapter}s#{loc.section}"""
			db.get id,(err,doc)->
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
			db.query """laws/all""",opts,(err,resp)->
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
			db.query """laws/all""",opts,(err,resp)->
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
			db.query """laws/all""",opts,(err,resp)->
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
			db.query """laws/all""",opts,(err,resp)->
				rows = resp.rows.map (row)->
					out = {}
					out.part= row.key.pop()
					out
				body.spin(false)
				body.$el.html(body.template.general({rowg:rows,g:true}))
	
	el:$ '#mainContent'
window.body = body
class Routes extends Backbone.Router
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
		body.spin()
		parts = 
			type:type
			part:part
			title:title
			chapter:chapter
			section:section
		parts.chapter = parseInt(parts.chapter,10) unless parts.chapter is 'all'
		parts.section = parseInt(parts.section,10) unless parts.section is 'all'
		body.render parts
	qoo:(query)->
		body.spin()
		body.render {q:query}
	nStyle:(path)->
		body.spin()
		if 's' in path
			split = path.split('s')
			parts=
				newStyleName:true
				c:split[0]
				s:split[1]
			body.render parts
		else if 'a' in path
			split = path.split('a')
			parts=
				c:split[0]
				a:split[1]
			body.render parts
	session:(path)->
		body.spin()
		if 'c' in path
			split = path.split('c')
			parts = 
				y:split[0]
				c:split[1]
			body.render parts
	years:(year='all')->
		body.spin()
		body.render
			type:'session'
			year:year
routes = new Routes

###nav = new View
	render:(location)->
		true
	template:"""
		<ul>
		{{#items}}
		
		{{/items}}
		</ul>
	"""
	el:$ '#navBar'
	###


start = (dbname)=>
	db = Pouch "#{location.protocol}//#{location.host}//law",(err,rslt)->
		Backbone.history.start
			pushState: true
			hashChange: false
		window.db = db
	$('#searchForm').on 'submit', (e)->
		e.preventDefault()
		routes.navigate 'q/'+$('#searchBox').val(),
			trigger:true
start('law')
