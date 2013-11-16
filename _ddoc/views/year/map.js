function(doc){
	if(doc.text && doc.year){
		emit(doc.year);
	}
}
