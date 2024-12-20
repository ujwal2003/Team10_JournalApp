//
//  AppController.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/2/24.
//

import Foundation
import SwiftUI

@MainActor
class AppViewController: ObservableObject {
    @Published var loggedIn: Bool = false
    @Published var viewSignUpFlag: Bool = false
    
    @Published var loadedUserProfile: UserProfile?
    
    @Published var isJournalInEditMode: Bool = false
    @Published var isShowingJournalInEditModeAlert: Bool = false
    @Published var savedIdToCityBlock: Bool = false
    
    @discardableResult
    func certifyAuthStatus(redirectToSignInIfNoAuth: Bool = false) -> AuthDataResultModel? {
        let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
        print(authUser ?? "authUser: NONE")
        
        self.loggedIn = authUser != nil
        
        if !loggedIn {
            viewSignUpFlag = redirectToSignInIfNoAuth ? false : viewSignUpFlag
            print("SYSTEM: No authenticated user found.")
        }
        
        return authUser
    }
    
}
