//
//  Post.swift
//  PostIt
//
//  Created by Speednet on 09.08.2016.
//  Copyright © 2016 Patryk Bejgrowicz. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct Post {
    
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:FIRDatabaseReference?
    
    
    init (content:String, addedByUser:String, key:String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    
    init(snapshot:FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let postContent = snapshot.value!["content"] as? String {
            content = postContent
        }
        else {
            content = ""
        }
        
        if let postUser = snapshot.value!["addedByUser"] as? String {
            addedByUser = postUser
        } else {
            addedByUser = ""
        }
    }
    
    
    func toAnyObject() -> AnyObject {
        return ["content":content, "addedByUser":addedByUser]
    }
    
}
