//
//  SignInViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/20/24.
//

import Foundation

@MainActor
class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn(onSignIn: @escaping () -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        Task {
            do {
                let userData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                print("Sucessfully signed in user: \(email)")
                print(userData)
                
                onSignIn()
                
            } catch {
                print("Failed to sign in user with error: \(error)")
            }
        }
    }
    
}
