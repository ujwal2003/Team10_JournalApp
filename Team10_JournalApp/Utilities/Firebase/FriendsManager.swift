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
    
    private func userFriendDocumentReference(userId: String, friendId: String) async throws -> DocumentReference {
        let query = userFriendsCollection(userId: userId)
            .whereField("friend_user_id", isEqualTo: friendId)
            .limit(to: 1)
        
        let querySnapshot = try await query.getDocuments()
        guard let document = querySnapshot.documents.first else {
            throw FirestoreDataError.userFriendNotFound(userID: userId, friendID: friendId)
        }
        
        return document.reference
    }
    
    func getUserFriend(userId: String, friendId: String) async throws -> UserFriendStatus {
        try await userFriendDocumentReference(userId: userId, friendId: friendId).getDocument(as: UserFriendStatus.self)
    }
    
    func getNumberOfFriends(userId: String) async throws -> Int {
        let query = userFriendsCollection(userId: userId)
            .whereField("user_friend_status", isEqualTo: FriendStatus.friend.rawValue)
            .count
        
        let querySnapshot = try await query.getAggregation(source: .server)
        return querySnapshot.count.intValue
    }
}
