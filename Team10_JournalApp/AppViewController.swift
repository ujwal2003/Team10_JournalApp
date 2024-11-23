//
//  AppController.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/2/24.
//

import Foundation
import SwiftUI

let isIphone16ProMaxPortrait: Bool = UIScreen.main.bounds.height == 956.0

class AppViewController: ObservableObject {
    @Published var loggedIn: Bool = false
    @Published var viewSignUpFlag: Bool = false
    
    @Published var loadedUserProfile: UserProfile?
    
    func certifyAuthStatus(redirectToSignInIfNoAuth: Bool = false) {
        let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
        print(authUser ?? "authUser: NONE")
        
        self.loggedIn = authUser != nil
        
        if !loggedIn {
            viewSignUpFlag = redirectToSignInIfNoAuth ? false : viewSignUpFlag
            print("SYSTEM: No authenticated user found.")
        }
    }
    
}
