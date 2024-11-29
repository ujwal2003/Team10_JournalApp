//
//  SettingsViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/20/24.
//

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    
    func signOut(onSignOut: () -> Void) {
        do {
            try AuthenticationManager.shared.signOutUser()
            onSignOut()
        } catch {
            print("Failed to sign out with error: \(error)")
        }
    }
    
}
