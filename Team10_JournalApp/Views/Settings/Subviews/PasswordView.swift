//
//  PasswordView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 12/1/24.
//

import SwiftUI

struct PasswordView: View {
    @ObservedObject var appController: AppViewController
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    @State private var currPassword: String = ""
    @State private var newPassword: String = ""
    @State private var passwordRetyped: String = ""
    
    @State private var isShowingPasswordChangeFailedAlert: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    private func anyFieldsEmpty() -> Bool {
        return currPassword.isEmpty || newPassword.isEmpty || passwordRetyped.isEmpty
    }
    
    private func newAndRetypedMatch() -> Bool {
        return newPassword == passwordRetyped
    }
    
    private func isDoneButtonDisabled() -> Bool {
        return anyFieldsEmpty() || !newAndRetypedMatch() || settingsViewModel.isChangingPasswordLoading
    }

    var body: some View {
        NavigationStack {
            // Page title
            AppLayoutContainer(height: 20.0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Update Password")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical, DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
                    .isLandscape(device: .iPhone) ? 0 : 20)
            } containerContent: {
                // Conditional ScrollView for landscape mode
                if DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass).isLandscape(device: .iPhone) {
                    ScrollView {
                        content
                    }
                    .scrollIndicators(.never)
                } else {
                    content
                }
            }
        }
    }

    // Main content of the PasswordView
    private var content: some View {
        VStack(spacing: 20) {
            ZStack {
                // Text Fields
                VStack {
                    // Current password field
                    secureField("Current Password", text: $currPassword)
                        .padding(.top, 25)
                    
                    // New password field
                    secureField("New Password", text: $newPassword)
                    
                    // Confirm new password field
                    secureField("Retype New Password", text: $passwordRetyped)
                        .padding(.bottom, 25)
                }
                
                if settingsViewModel.isChangingPasswordLoading {
                    ProgressBufferView(backgroundColor: Color(.systemGray5).opacity(0.85)) {
                        Text("Please wait...")
                    }
                }
            }
            
            // Done button
            Button(action: {
                settingsViewModel.isShowingUpdatePasswordConfirmationAlert.toggle()
            }) {
                Text("Done")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 315, height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(Color(red: 0.09, green: 0.28, blue: 0.39))
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    )
                    .opacity(isDoneButtonDisabled() ? 0.5 : 1.0)
            }
            .disabled(isDoneButtonDisabled())
            .alert("Password Change Failed", isPresented: $isShowingPasswordChangeFailedAlert) {
                Button("Ok") { }
            } message: {
                Text("Failed to change your password. You entered the incorrect current password or there was a network or server issue, please try again.")
            }
            .alert("Are You Sure?", isPresented: $settingsViewModel.isShowingUpdatePasswordConfirmationAlert) {
                Button("Yes") {
                    if let profile = appController.loadedUserProfile {
                        settingsViewModel.changeUserPassword(
                            email: profile.email,
                            currPassword: currPassword,
                            newPassword: newPassword) { reAuthUser in
                                print("[SYSTEM]: Successfully changed password \n \(reAuthUser)")
                                settingsViewModel.isShowingPasswordChangeSuccessAlert.toggle()
                                
                            } onFailure: {
                                self.currPassword = ""
                                self.newPassword = ""
                                self.passwordRetyped = ""
                                
                                self.isShowingPasswordChangeFailedAlert.toggle()
                            }
                    }
                }
                
                Button("No") { }
                
            } message: {
                Text("Are you sure you want to change your password? You will be asked to sign in again with your new password.")
            }
            .alert("Password Changed", isPresented: $settingsViewModel.isShowingPasswordChangeSuccessAlert) {
                Button("Ok") {
                    dismiss()
                    settingsViewModel.signOut {
                        self.appController.loadedUserProfile = nil
                        self.appController.viewSignUpFlag = false
                        self.appController.loggedIn = false
                    }
                }
            } message: {
                Text("Password successfully changed, please sign in again.")
            }
            
            Spacer()
        }
    }
    
    // Helper method for creating secure text fields
    private func secureField(_ placeholder: String, text: Binding<String>) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 315, height: 52)
                .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                )
            
            SecureField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 5)
                .frame(width: 295, height: 52)
                .foregroundColor(.black)
                .submitLabel(.next)
                .disabled(settingsViewModel.isChangingPasswordLoading)
        }
    }
}

#Preview {
    PasswordView(
        appController: AppViewController(),
        settingsViewModel: SettingsViewModel()
    )
}
