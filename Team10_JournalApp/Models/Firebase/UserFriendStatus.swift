//
//  UserFriendStatus.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/30/24.
//

import Foundation
import FirebaseFirestore

enum FriendStatus: String {
    case friend = "friend"
    case incomingRequest = "incoming_request"
    case invited = "invited"
    case unknown
}

struct UserFriendStatus: Codable {
    @DocumentID var friendsSubcollectionId: String?
    let friendUserId: String
    let userFriendStatus: String
    
    var status: FriendStatus {
        FriendStatus(rawValue: userFriendStatus) ?? .unknown
    }
    
    init(friendsSubcollectionId: String? = nil, friendUserId: String, userFriendStatus: String) {
        self.friendsSubcollectionId = friendsSubcollectionId
        self.friendUserId = friendUserId
        self.userFriendStatus = userFriendStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case friendsSubcollectionId = "friends_subcollection_id"
        case friendUserId = "friend_user_id"
        case userFriendStatus = "user_friend_status"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._friendsSubcollectionId = try container.decode(DocumentID<String>.self, forKey: .friendsSubcollectionId)
        self.friendUserId = try container.decode(String.self, forKey: .friendUserId)
        self.userFriendStatus = try container.decode(String.self, forKey: .userFriendStatus)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.friendsSubcollectionId, forKey: .friendsSubcollectionId)
        try container.encode(self.friendUserId, forKey: .friendUserId)
        try container.encode(self.userFriendStatus, forKey: .userFriendStatus)
    }
}
