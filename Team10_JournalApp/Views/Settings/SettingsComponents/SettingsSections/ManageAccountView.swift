//
//  ManageAccountView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/2/24.
//

import SwiftUI

struct ManageAccountView: View {
    @StateObject var appController: AppViewController
    @StateObject var settingsViewModel: SettingsViewModel
    
    @Binding var isShowingChangeCredentialsAlert: Bool
    @Binding var isShowingSignOutAlert: Bool
    @Binding var isShowingDeleteAccountAlert: Bool
    
    @State var password: String = ""
    
    var body: some View {
        Section(header:
                    Text("Manage Account")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.black)
            .textCase(nil)
            .frame(height: 0, alignment: .center)
            .padding(.leading, 25)
        ) {
            // Reset Journal Button with alert
            Button(action: {
                isShowingChangeCredentialsAlert = true
            }) {
                SettingButtonView(buttonText: "Reset Journal", isDeleteButton: false)
            }
            .alert("Reset Journal?", isPresented: $isShowingChangeCredentialsAlert) {
                Button("No") { }
                Button("Yes") {
                    if let profile = appController.loadedUserProfile {
                        settingsViewModel.resetUserJournal(userId: profile.userId)
                    }
                }
            } message: {
                Text("Are you sure you want to clear all entries and restart? This action cannot be undone!")
            }
            .alert("Failed to Reset", isPresented: $settingsViewModel.isShowingJournalResetFailedAlert) {
                Button("Ok") { }
            } message: {
                Text("Failed to reset journal, this may be due to a network or server issue. Please try again.")
            }

            
            // Sign Out Button with alert
            Button(action: {
                isShowingSignOutAlert = true
            }) {
                SettingButtonView(buttonText: "Sign Out", isDeleteButton: false)
            }
            .alert("Sign Out?", isPresented: $isShowingSignOutAlert) {
                Button("No") { }
                Button("Yes") {
                    settingsViewModel.signOut {
                        self.appController.loadedUserProfile = nil
                        self.appController.viewSignUpFlag = false
                        self.appController.loggedIn = false
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            
            // Delete Account Button with alert
            Button(action: {
                isShowingDeleteAccountAlert = true
            }) {
                SettingButtonView(buttonText: "Delete Account", isDeleteButton: true)
            }
            .alert("Delete account?", isPresented: $isShowingDeleteAccountAlert) {
                Button("No") { }
                Button("Yes") {
                    settingsViewModel.isPasswordConfirmationForAccountDeletionDialogShowing.toggle()
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone!")
            }
            .alert("Enter Password to Confirm", isPresented: $settingsViewModel.isPasswordConfirmationForAccountDeletionDialogShowing) {
                
                SecureField("Password", text: $password)
                
                Button("OK") {
                    if let profile = appController.loadedUserProfile {
                        settingsViewModel.deleteUserAccount(
                            userProfile: profile,
                            password: self.password
                        ) {
                            settingsViewModel.signOut {
                                self.appController.loadedUserProfile = nil
                                self.appController.viewSignUpFlag = false
                                self.appController.loggedIn = false
                            }
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) { }
                
            } message: {
                Text("Please enter your password to proceed with account deletion.")
            }
            .alert("Error Encountered", isPresented: $settingsViewModel.isShowingDeleteAccountFailedAlert) {
                Button("Ok") {
                    settingsViewModel.signOut {
                        self.appController.loadedUserProfile = nil
                        self.appController.viewSignUpFlag = false
                        self.appController.loggedIn = false
                    }
                }
            } message: {
                Text("Either your password was invalid or there was a network issue. You will be signed out, you may sign back in and try again or contact support if the issue persists.")
            }


            
        }
        .listRowSeparator(.hidden)
        .padding(.top, -10)
    }
}

#Preview {
    ManageAccountView(
        appController: AppViewController(),
        settingsViewModel: SettingsViewModel(),
        isShowingChangeCredentialsAlert: .constant(false),
        isShowingSignOutAlert: .constant(false),
        isShowingDeleteAccountAlert: .constant(false)
    )
}
