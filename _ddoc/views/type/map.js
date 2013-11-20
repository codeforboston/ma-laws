function(doc){
	if(doc.year){
		emit('session');
	}else if(doc.part&&doc.title){
		emit('general');
	}
}