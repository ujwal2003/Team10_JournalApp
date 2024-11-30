//
//  FriendsManager.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/30/24.
//

import Foundation
import FirebaseFirestore

final class FriendsManager {
    static let shared = FriendsManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userFriendsCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("user_friends")
    }
    
    private func userFriendDocument(userId: String, friendId: String) -> DocumentReference {
        userFriendsCollection(userId: userId).document(friendId)
    }
    
    func getNumberOfFriends(userId: String) async throws -> Int {
        let query = userFriendsCollection(userId: userId)
            .whereField("user_friend_status", isEqualTo: FriendStatus.friend.rawValue)
            .count
        
        let querySnapshot = try await query.getAggregation(source: .server)
        return querySnapshot.count.intValue
    }
    
    func addNewFriendWithStatus(userId: String, friendId: String, status: FriendStatus) async throws {
        let newFriendUser = UserFriendStatus(friendUserId: friendId, userFriendStatus: status.rawValue)
        try userFriendDocument(userId: userId, friendId: friendId).setData(from: newFriendUser, merge: false)
    }
}
