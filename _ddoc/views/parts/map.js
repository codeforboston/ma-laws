function(doc){
	if(doc.text && doc.part){
		emit(doc.part)
	}
}
