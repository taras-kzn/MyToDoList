//
//  User.swift
//  MyToDoList
//
//  Created by admin on 14.03.2021.
//  Copyright © 2021 admin. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: String
    let email: String
    
    init(user: FirUser) {
        self.uid = user.uid
        self.email = user.email
    }
}
