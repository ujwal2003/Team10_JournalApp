//
//  AuthDataResultModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/19/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email ?? "NONE"
        self.photoUrl = user.photoURL?.absoluteString
    }
}
