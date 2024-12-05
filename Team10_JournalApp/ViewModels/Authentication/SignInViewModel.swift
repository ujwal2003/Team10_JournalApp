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
    
    @Published var isLoading: Bool = false
    @Published var isShowingSignInFailedAlert: Bool = false
    
    func signIn(onSignIn: @escaping (UserProfile) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        Task {
            self.isLoading = true
            
            do {
                let userData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                print("Sucessfully signed in user: \(email)")
                
                let userProfile = try await UserManager.shared.getUser(userId: userData.uid)
                
                self.isLoading = false
                
                print(userProfile)
                onSignIn(userProfile)
                
            } catch {
                self.isLoading = false
                
                print("Failed to sign in user with error: \(error)")
                self.isShowingSignInFailedAlert.toggle()
            }
        }
    }
    
}
