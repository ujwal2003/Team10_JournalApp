//
//  SettingsViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/20/24.
//

import Foundation

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var isUpdateDisplayNameLoading: Bool = false
    
    @Published var isChangingPasswordLoading: Bool = false
    @Published var isShowingUpdatePasswordConfirmationAlert: Bool = false
    @Published var isShowingPasswordChangeSuccessAlert: Bool = false
    
    @Published var isResettingJournal: Bool = false
    @Published var isShowingJournalResetFailedAlert: Bool = false
    
    @Published var isSendingEmailVerificationLoading: Bool = false
    @Published var isShowingUpdateEmailConfirmationAlert: Bool = false
    @Published var isShowingVerifyEmailSentSuccessAlert: Bool = false
    @Published var isShowingEmailChangeFailedAlert: Bool = false
    
    func signOut(onSignOut: () -> Void) {
        do {
            try AuthenticationManager.shared.signOutUser()
            onSignOut()
        } catch {
            print("Failed to sign out with error: \(error)")
        }
    }
    
    func changeDisplayName(userId: String, newName: String, onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        guard !userId.isEmpty, !newName.isEmpty else {
            return
        }
        
        Task {
            self.isUpdateDisplayNameLoading = true
            
            do {
                try await UserManager.shared.updateUserDisplayName(userId: userId, displayName: newName)
                self.isUpdateDisplayNameLoading = false
                onSuccess()
            } catch {
                self.isUpdateDisplayNameLoading = false
                onFailure()
            }
        }
    }
    
    func changeUserPassword(email: String, currPassword: String, newPassword: String, onSuccess: @escaping (UserProfile) -> Void, onFailure: @escaping () -> Void) {
        guard !email.isEmpty, !currPassword.isEmpty, !newPassword.isEmpty else {
            return
        }
        
        Task {
            self.isChangingPasswordLoading = true
            
            do {
                let reauthenticatedUser = try await AuthenticationManager.shared.reauthenticateUser(email: email, password: currPassword)
                try await AuthenticationManager.shared.updatePassword(newPassword: newPassword)
                
                let reAuthUserProfile = try await UserManager.shared.getUser(userId: reauthenticatedUser.uid)
                
                self.isChangingPasswordLoading = false
                
                onSuccess(reAuthUserProfile)
                
            } catch {
                self.isChangingPasswordLoading = false
                onFailure()
            }
        }
    }
    
    func changeUserEmail(currEmail: String, password: String, newEmail: String) {
        guard !currEmail.isEmpty, !password.isEmpty, !newEmail.isEmpty else {
            return
        }
        
        Task {
            self.isSendingEmailVerificationLoading = true
            
            do {
                
                _ = try await AuthenticationManager.shared.reauthenticateUser(email: currEmail, password: password)
                try await AuthenticationManager.shared.updateEmail(newEmail: newEmail)
                
                self.isSendingEmailVerificationLoading = false
                self.isShowingVerifyEmailSentSuccessAlert = true
                
            } catch {
                self.isSendingEmailVerificationLoading = false
                self.isShowingEmailChangeFailedAlert = true
            }
        }
    }
    
    func resetUserJournal(userId: String) {
        Task {
            self.isResettingJournal = true
            
            do {
                try await CityBlockManager.shared.bulkDeleteAllUserCityBlockData(userId: userId)
                try await JournalManager.shared.bulkDeleteAllUserJournalEntries(userId: userId)
                
                self.isResettingJournal = false
                
            } catch {
                self.isResettingJournal = false
                self.isShowingJournalResetFailedAlert.toggle()
            }
        }
    }
    
}
