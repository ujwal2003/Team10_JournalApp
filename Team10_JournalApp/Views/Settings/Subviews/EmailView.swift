//
//  EmailView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 12/1/24.
//

import SwiftUI

struct EmailView: View {
    @ObservedObject var appController: AppViewController
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    @State private var currEmail: String = ""
    @State private var password: String = ""
    @State private var newEmail: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    func anyFieldsEmpty() -> Bool {
        return currEmail.isEmpty || password.isEmpty || newEmail.isEmpty
    }
    
    func isDoneButtonDisabled() -> Bool {
        return anyFieldsEmpty() || settingsViewModel.isSendingEmailVerificationLoading
    }

    var body: some View {
        NavigationStack {
            // Page title
            AppLayoutContainer(height: 20.0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Update Email")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                    
                    Text("\(Image(systemName: "exclamationmark.triangle")) This will send a verification to your current email address before updating.")
                        .font(.system(size: 16.0))
                        .padding(.horizontal, 40.0)
                }
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
    
    // Main content of the EmailView
    private var content: some View {
        VStack(spacing: 20) {
            ZStack {
                // Text Fields
                VStack {
                    // Current email text field
                    emailTextField("Current Email Address", text: $currEmail)
                        .padding(.top, 25)
                    
                    // Password text field
                    passwordTextField("Password", text: $password)
                        .padding(.vertical, 10)
                    
                    // New email text field
                    emailTextField("New Email Address", text: $newEmail)
                        .padding(.bottom, 25)
                }
                
                if settingsViewModel.isSendingEmailVerificationLoading {
                    ProgressBufferView(backgroundColor: Color(.systemGray5).opacity(0.85)) {
                        Text("Please wait...")
                    }
                }
            }
            
            // Done button
            Button(action: {
                settingsViewModel.isShowingUpdateEmailConfirmationAlert.toggle()
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
            .alert("Are You Sure?", isPresented: $settingsViewModel.isShowingUpdateEmailConfirmationAlert) {
                Button("Yes") {
                    settingsViewModel.changeUserEmail(currEmail: currEmail, password: password, newEmail: newEmail)
                }
                Button("No") { }
            } message: {
                Text("This will send a verification link to \(newEmail) to verify it as your new email. A reset link will be sent to \(currEmail) should you choose to revert this action.")
            }
            .alert("Email Verification Sent", isPresented: $settingsViewModel.isShowingVerifyEmailSentSuccessAlert) {
                Button("Ok") {
                    dismiss()
                    settingsViewModel.signOut {
                        self.appController.loadedUserProfile = nil
                        self.appController.viewSignUpFlag = false
                        self.appController.loggedIn = false
                    }
                }
            } message: {
                Text("You will now be signed out of the app, please sign in after you verify your new email.")
            }
            .alert("Failed to Change Email", isPresented: $settingsViewModel.isShowingEmailChangeFailedAlert) {
                Button("Ok") {}
            } message: {
                Text("Failed to send a verification email to \(currEmail). Your current credentials are incorrect or there was a network issue.")
            }
            
            Spacer()
        }
    }
    
    // Helper method for creating email text fields
    private func emailTextField(_ placeholder: String, text: Binding<String>) -> some View {
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
            
            TextField(placeholder, text: text)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 5)
                .frame(width: 295, height: 52)
                .foregroundColor(.black)
                .submitLabel(.next)
                .disabled(settingsViewModel.isSendingEmailVerificationLoading)
        }
    }
    
    // Helper method for creating password text fields
    private func passwordTextField(_ placeholder: String, text: Binding<String>) -> some View {
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
                .disabled(settingsViewModel.isSendingEmailVerificationLoading)
        }
    }
}

#Preview {
    EmailView(appController: AppViewController(), settingsViewModel: SettingsViewModel())
}
