//
//  UserManager.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/22/24.
//

import Foundation
import FirebaseFirestore

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func getUser(userId: String) async throws -> UserProfile {
        try await userDocument(userId: userId).getDocument(as: UserProfile.self)
    }
    
    func createNewUser(user: UserProfile) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func updateUserDisplayName(userId: String, displayName: String) async throws {
        let data: [String: Any] = [
            UserProfile.CodingKeys.displayName.rawValue : displayName
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addFriend(userId: String, friendUserId: String) async throws {
        let data: [String: Any] = [
            UserProfile.CodingKeys.friendUserIDs.rawValue: FieldValue.arrayUnion([friendUserId])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeFriend(userId: String, friendUserId: String) async throws {
        let data: [String: Any] = [
            UserProfile.CodingKeys.friendUserIDs.rawValue: FieldValue.arrayRemove([friendUserId])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
}
