function(doc){
    if(doc.text && doc.type){
        index("default", doc.text);
    }
}