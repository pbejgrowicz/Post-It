//
//  User.swift
//  PostIt
//
//  Created by Speednet on 09.08.2016.
//  Copyright © 2016 Patryk Bejgrowicz. All rights reserved.
//

import Foundation
import FirebaseAuth


struct User {
    let uid:String
    let email:String
    
    init(userData:FIRUser) {
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email {
            email = mail
        }
        else {
            email = ""
        }
    }
    
    init (uid:String, email:String) {
        self.uid = uid
        self.email = email
    }
    
    
}
