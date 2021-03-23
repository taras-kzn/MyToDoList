//
//  User.swift
//  MyToDoList
//
//  Created by admin on 14.03.2021.
//  Copyright © 2021 admin. All rights reserved.
//

import Foundation
import Firebase

struct UserModel {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
