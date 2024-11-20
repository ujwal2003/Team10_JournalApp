//
//  AuthenticationManager.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/19/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    /// Checks if the user is authenticated on the local device
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.authenticatedUserNotFound
        }
        
        return AuthDataResultModel(user: user)
    }
    
    /// Signs up a user with the email and password
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOutUser() throws {
        try Auth.auth().signOut()
    }
    
    /// Sends a password reset link to the user email
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    /// Updates the password of the already authenticated user
    func updatePassword(newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.authenticatedUserNotFound
        }
        
        try await user.updatePassword(to: newPassword)
    }
    
    /// Deletes the already authenticated user
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.authenticatedUserNotFound
        }
        
        try await user.delete()
    }
    
}
