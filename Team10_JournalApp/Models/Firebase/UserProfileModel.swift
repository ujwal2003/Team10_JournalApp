//
//  UserProfileModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/22/24.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Codable {
    let userId: String
    let email: String
    let displayName: String
    let dateCreated: Date
    let photoURL: String?
    let friendUserIDs: [String]
    
    init(authUser: AuthDataResultModel) {
        self.userId = authUser.uid
        self.email = authUser.email
        self.displayName = authUser.email
        self.dateCreated = Date()
        self.photoURL = authUser.photoUrl
        self.friendUserIDs = []
    }
    
    init(userId: String, email: String, displayName: String, dateCreated: Date, photoURL: String?, friendUserIDs: [String]) {
        self.userId = userId
        self.email = email
        self.displayName = displayName
        self.dateCreated = dateCreated
        self.photoURL = photoURL
        self.friendUserIDs = friendUserIDs
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case displayName = "display_name"
        case dateCreated = "date_created"
        case photoURL = "photo_url"
        case friendUserIDs = "friend_user_ids"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.friendUserIDs = try container.decode([String].self, forKey: .friendUserIDs)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.friendUserIDs, forKey: .friendUserIDs)
    }
}
