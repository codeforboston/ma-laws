ma-laws
=======
laws of Massachusetts as JSON, there is also a [version in couchdb](https://cloudant.com/futon/database.html?kublai%2Flaw/_all_docs) feel free to replicate it and a [work in progress web app](http://macode.org/)

or just query the web api each list is available as a page or as JSON, the JSON is also available as JSONP by appending `?callback=callback`

get a section as JSON

```
http://macode.org/db/c{{chapter}}s{{section}}
```

as JSONP

```
http://macode.org/db/c{{chapter}}s{{section}}?callback={{callback}}
```

as HTML

```
http://macode.org/c{{chapter}}s{{section}}
```

e.g. section 2 of chapter 276 is http://macode.org/db/c276s2 for JSON, http://macode.org/db/c276s2?callback=cb for JSONP and http://macode.org/c276s2 for HTML

you can use the web app to find them as HTML, the JSON formulae are as follows

- chapter: `http://macode.org/api/chapter/{{chapter}}` e.g. http://macode.org/api/chapter/276
- title: `http://macode.org/api/{{part}}/{{title}}` e.g. http://macode.org/api/IV/II note the upper case roman numerals
- part: `http://macode.org/api/part/{{part}}` e.g. http://macode.org/api/part/IV note the upper case roman numerals
- chapter of session law: `http://macode.org/db/y{{year}}c{{chapter}}` e.g. http://macode.org/db/y2013c2
- year of session law: `http://macode.org/api/year/{{year}}` e.g. http://macode.org/api/year/2003
- all general law: http://macode.org/api/general
- all session law: http://macode.org/api/session
- search: http://macode.org/api/search/{{term}} e.g. http://macode.org/api/search/cranberry