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
    
    func signUp(onSignUp: @escaping () -> Void) {
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
                print(userData)
                
                onSignUp()
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
}
