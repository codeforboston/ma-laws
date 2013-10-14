function(doc){
	if(doc.type&&doc.year&&doc.chapter){
		emit([doc.type,parseInt(doc.year,10),doc.chapter]);
	}
}
