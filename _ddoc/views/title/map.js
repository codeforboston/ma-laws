function(doc){
	if(doc.text && doc.part && doc.title){
		emit([doc.part,doc.title])
	}
}
