function(doc){
	if(doc.text && doc.chapter && doc.section){
		emit(doc.chapter)
	}
}
