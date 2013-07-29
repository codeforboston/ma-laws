function(doc){
	if(doc.text && doc.type){
		emit([doc.type,doc.part,doc.title,doc.chapter,doc.section])
	}
}
