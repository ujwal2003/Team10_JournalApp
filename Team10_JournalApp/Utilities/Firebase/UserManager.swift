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
    
    /// Updates the user's email on their profile.
    /// This does not update authentication, see: `AuthenticationManager.shared.updateEmail(newEmail: String)`
    /// Update authentication email prior to updating profile email.
    func updateUserProfileEmail(userId: String, newEmail: String) async throws {
        let data: [String: Any] = [
            UserProfile.CodingKeys.email.rawValue : newEmail
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserDisplayName(userId: String, displayName: String) async throws {
        let data: [String: Any] = [
            UserProfile.CodingKeys.displayName.rawValue : displayName
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func updateUserLocation(userId: String, newLati: Double, newLongi: Double) async throws {
        let data: [String: Any] = [
            UserProfile.CodingKeys.locLati.rawValue : newLati,
            UserProfile.CodingKeys.locLongi.rawValue : newLongi
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
}
