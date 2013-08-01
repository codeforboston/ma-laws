function(doc){
    if(doc.text && doc.type){
        index("default", doc.text);
        index("default", doc.desc);
    }
}
