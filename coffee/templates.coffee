Mustache = require 'mustache'

module.exports =
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
