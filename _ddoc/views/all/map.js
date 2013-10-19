function(doc){
	if(doc.text && doc.type){
		if(doc.section){
			emit([doc.type,doc.part,doc.title,doc.chapter,doc.section])
		}else if(doc.article){
			emit([doc.type,doc.part,doc.title,doc.chapter,doc.article])
		}
	}
}
