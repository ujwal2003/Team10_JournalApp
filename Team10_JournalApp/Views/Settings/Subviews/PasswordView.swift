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
        return anyFieldsEmpty() || !newAndRetypedMatch()
    }

    var body: some View {
        NavigationStack {
            // Page title
            AppLayoutContainer(height: 20.0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Password")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                if settingsViewModel.isChangingPasswordLoading {
                    ProgressBufferView {
                        Text("Loading...")
                    }
                }
                
                VStack(spacing: 20) {
                    // Secure field for entering the current password
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
                        
                        SecureField("Current Password", text: $currPassword)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 5)
                            .frame(width: 295, height: 52)
                            .foregroundColor(.black)
                            .submitLabel(.next)
                            .disabled(settingsViewModel.isChangingPasswordLoading)
                    }
                    .padding(.top, 25)
                    
                    // Secure field for entering a new password
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
                        
                        SecureField("New Password", text: $newPassword)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 5)
                            .frame(width: 295, height: 52)
                            .foregroundColor(.black)
                            .submitLabel(.next)
                            .disabled(settingsViewModel.isChangingPasswordLoading)
                    }
                    
                    // Secure field for confirming the new password
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
                        
                        SecureField("Retype New Password", text: $passwordRetyped)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 5)
                            .frame(width: 295, height: 52)
                            .foregroundColor(.black)
                            .submitLabel(.next)
                            .disabled(settingsViewModel.isChangingPasswordLoading)
                    }
                    .padding(.bottom, 25)
                    
                    // Done button to save the new password
                    Button(action: {
                        if let profile = appController.loadedUserProfile {
                            settingsViewModel.changeUserPassword(
                                email: profile.email,
                                currPassword: currPassword,
                                newPassword: newPassword) { reAuthUser in
                                    
                                    self.appController.loadedUserProfile = reAuthUser
                                    print("[SYSTEM]: Succesfully changed password")
                                    dismiss()
                                    
                                } onFailure: {
                                    self.currPassword = ""
                                    self.newPassword = ""
                                    self.passwordRetyped = ""
                                    
                                    self.isShowingPasswordChangeFailedAlert.toggle()
                                }
                        }
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
                        Text("Failed to change your password. You enetered the incorrect current password or there was a network or server issue, please try again.")
                    }

                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PasswordView(
        appController: AppViewController(),
        settingsViewModel: SettingsViewModel()
    )
}
