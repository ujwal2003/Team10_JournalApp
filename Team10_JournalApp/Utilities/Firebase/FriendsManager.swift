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
    
    func addUserNewFriendWithStatus(userId: String, friendId: String, status: FriendStatus) async throws {
        let newFriendUser = UserFriendStatus(friendUserId: friendId, userFriendStatus: status.rawValue)
        try userFriendDocument(userId: userId, friendId: friendId).setData(from: newFriendUser, merge: false)
    }
    
    func updateUserFriendStatus(userId: String, friendId: String, status: FriendStatus) async throws {
        let data: [String: Any] = [
            UserFriendStatus.CodingKeys.userFriendStatus.rawValue : status.rawValue
        ]
        
        try await userFriendDocument(userId: userId, friendId: friendId).updateData(data)
    }
    
    func getNumberOfFriends(userId: String) async throws -> Int {
        let query = userFriendsCollection(userId: userId)
            .whereField("user_friend_status", isEqualTo: FriendStatus.friend.rawValue)
            .count
        
        let querySnapshot = try await query.getAggregation(source: .server)
        return querySnapshot.count.intValue
    }
    
    func getAllUserFriendsWithStatus(userId: String, status: FriendStatus) async throws -> [UserFriendStatus] {
        let query = userFriendsCollection(userId: userId)
            .whereField("user_friend_status", isEqualTo: status.rawValue)
        
        let querySnapshot = try await query.getDocuments()
        
        var friendStatuses: [UserFriendStatus] = []
        for document in querySnapshot.documents {
            let friend = try document.data(as: UserFriendStatus.self)
            friendStatuses.append(friend)
        }
        
        return friendStatuses
    }
    
    func removeUserFriendWithStatus(userId: String, friendId: String, status: FriendStatus) async throws {
        let query = userFriendsCollection(userId: userId)
            .whereField("user_friend_status", isEqualTo: status.rawValue)
            .limit(to: 1)
        
        let querySnapshot = try await query.getDocuments()
        guard let document = querySnapshot.documents.first else {
            throw FirestoreDataError.userFriendNotFound(userID: userId, friendID: friendId)
        }
        
        let data = try document.data(as: UserFriendStatus.self)
        
        try await userFriendsCollection(userId: userId).document(data.friendUserId).delete()
    }
}
