//
//  SignUpViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/19/24.
//

import Foundation

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var retypedPassword: String = ""
    
    @Published var isSignUpFailedAlertShowing: Bool = false
    
    func signUp(onSignUp: @escaping (UserProfile) -> Void) {
        guard !email.isEmpty, !password.isEmpty, !retypedPassword.isEmpty else {
            print("No email or password found")
            return
        }
        
        guard password == retypedPassword else {
            print("Passwords do not match")
            return
        }
        
        Task {
            do {
                let userData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Succesfully created user: \(email)")
                
                let newUser = UserProfile(authUser: userData)
                try await UserManager.shared.createNewUser(user: newUser)
                
                print(newUser)
                onSignUp(newUser)
                
            } catch {
                print("Failed to sign up with error: \(error)")
                self.isSignUpFailedAlertShowing.toggle()
            }
        }
    }
    
}