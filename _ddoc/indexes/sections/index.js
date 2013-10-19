function(doc){
    if(doc.text && doc.type){
        index("default", doc.text);
        if(doc.desc){
            index("default", doc.desc);
        }
    }
}
