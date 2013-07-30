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
	template:
		search:Mustache.compile """
		<div class="row">
		<h1>"{{q}}"</h1>
		<p>{{total_rows}} results</p><dl>
		{{#rows}}<dt>
		<a class='bodyLink' href="../GeneralLaws" id="GeneralLaws">General Laws</a>/
		<a class='bodyLink' href='../GeneralLaws/Part{{doc.part}}' id="/GeneralLaws/Part{{doc.part}}">Part {{doc.part}}</a>/
  		<a class='bodyLink' href='../GeneralLaws/Part{{doc.part}}/Title{{doc.title}}' id="/GeneralLaws/Part{{doc.part}}/Title{{doc.title}}">Title {{doc.title}}</a>/
  		<a class='bodyLink' href='../GeneralLaws/Part{{doc.part}}/Title{{doc.title}}/Chapter{{doc.chapter}}' id="/GeneralLaws/Part{{doc.part}}/Title{{doc.title}}/Chapter{{doc.chapter}}">Chapter {{doc.chapter}}</a>/
  		<a class='bodyLink' href='../GeneralLaws/Part{{doc.part}}/Title{{doc.title}}/Chapter{{doc.chapter}}/Section{{doc.section}}' id="/GeneralLaws/Part{{doc.part}}/Title{{doc.title}}/Chapter{{doc.chapter}}/Section{{doc.section}}">Section {{doc.section}}</a>
  		</dt>
		{{#doc.desc}}<dd><strong>{{doc.desc}}</strong></dd>{{/doc.desc}}
		{{#doc.text}}<dd>{{doc.text}}</dd>{{/doc.text}}
		{{/rows}}
		</dl>
		<ul class="pager">

  <li class="next"><a href="#">Next &rarr;</a></li>
</ul>
		</div>
		"""
		section:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="../../../../GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			<li><a class='bodyLink' href='../../../Part{{part}}' id="/GeneralLaws/Part{{part}}">Part {{part}}</a></li>
  			<li><a class='bodyLink' href='../../Title{{title}}' id="/GeneralLaws/Part{{part}}/Title{{title}}">Title {{title}}</a></li>
  			<li><a class='bodyLink' href='../Chapter{{chapter}}' id="/GeneralLaws/Part{{part}}/Title{{title}}/Chapter{{chapter}}">Chapter {{chapter}}</a></li>
  			<li class="active">Section {{section}}</li>
		</ul>
		<h1>Section {{section}}</h1>
		{{#desc}}<h2>{{desc}}</h2>{{/desc}}
		{{#text}}<p>{{text}}</p>{{/text}}
		</div>
		"""
		chapter:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="../../../GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			<li><a class='bodyLink' href='../../Part{{doc.part}}' id="/GeneralLaws/Part{{pat}}">Part {{pat}}</a></li>
  			<li><a class='bodyLink' href='../Title{{doc.title}}' id="/GeneralLaws/Part{{pat}}/Title{{tit}}">Title {{tit}}</a></li>
  			<li class="active">Chapter {{chap}}</li>
		</ul>
		<h1>Chapter {{chap}}</h1>
		<dl>
		{{#rows}}
		{{#doc.desc}}<dt><strong>Section {{doc.section}}:</strong> <a class='bodyLink' href='Chapter{{doc.chapter}}/Section{{doc.section}}' id='GeneralLaws/Part{{doc.part}}/Title{{doc.title}}/Chapter{{doc.chapter}}/Section{{doc.section}}'>{{doc.desc}}</a></dt>{{/doc.desc}}
		{{#doc.text}}<dd>{{doc.text}}</dd>{{/doc.text}}
		{{/rows}}
		</dl>
		</div>
		"""
		title:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="../../GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			<li><a class='bodyLink' href='../Part{{tp}}' id="/GeneralLaws/Part{{tp}}">Part {{tp}}</a></li>
  			
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
		part:Mustache.compile """
		<div class="row">
		<ul class="breadcrumb">
  			<li><a class='bodyLink' href="../GeneralLaws" id="GeneralLaws">General Laws</a></li>
  			
  			
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
		if 'q' of loc
			@search(loc.q).then (resp)->
				console.log resp
				resp.q=loc.q
				body.$el.html(body.template.search(resp))
		else if loc.section isnt 'all'
			id = """#{loc.type}/Part#{loc.part}/Title#{loc.title}/Chapter#{loc.chapter}/Section#{loc.section}"""
			db.get id,(err,doc)->
				if err
					return
				else
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
				resp.chap = loc.chapter
				resp.tit=loc.title
				resp.pat = loc.part
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
				body.$el.html(body.template.general({rowg:rows,g:true}))
	
	el:$ '#mainContent'
window.body = body
class Routes extends Backbone.Router
	routes:
		':type': 'roo'
		':type/Part:part': 'roo'
		':type/Part:part/Title:title': 'roo'
		':type/Part:part/Title:title/Chapter:chapter': 'roo'
		':type/Part:part/Title:title/Chapter:chapter/Section:section': 'roo'
		'q/:query':'qoo'
		'*spat':'roo'
	roo:(type='home',part='all',title='all',chapter='all',section='all')->
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
		body.render {q:query}

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
	db = Pouch "#{location.protocol}//#{location.host}/#{dbname}",(err,rslt)->
		Backbone.history.start
			pushState: true
			root: "#{dbname}/_design/laws/_rewrite/"
			hashChange: false
		window.db = db
	$('#searchForm').on 'submit', (e)->
		e.preventDefault()
		routes.navigate 'q/'+$('#searchBox').val(),
			trigger:true
start('law')
