//
//  SettingView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/22/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var appController: AppViewController
    @StateObject var viewModel = SettingsViewModel()
    
    // User state variables
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    @State private var isShowingChangeCredentialsAlert: Bool = false
    @State private var isShowingSignOutAlert: Bool = false
    @State private var isShowingDeleteAccountAlert: Bool = false
    @State private var isSignedOut: Bool = false
    @State private var isLocationShared: Bool = false
    @State private var isNavigating = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            AppLayoutContainer(height: 20.0) {
                // Header for Settings
                VStack(alignment: .leading, spacing: 10) {
                    Text("Settings")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                // Main content of the settings
                VStack {
                    NavigationStack {
                        VStack {
                            List {
                                // Account Details Section
                                Section(header:
                                            Text("Account Details")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .frame(height: 0, alignment: .center)
                                    .padding(.leading, 25)
                                ) {
                                    // Display Name Button with navigation
                                    SettingButtonWithAccountDetailView(
                                        buttonText: "Display Name",
                                        accountDetail: appController.loadedUserProfile?.displayName ?? "[none]"
                                    )
                                    .background(
                                        NavigationLink(
                                            "",
                                            destination: DisplayNameView(appController: appController, settingsViewModel: viewModel)
                                        )
                                        .opacity(0)
                                    )
                                    
                                    // Email Button with navigation
                                    SettingButtonWithAccountDetailView(
                                        buttonText: "Email",
                                        accountDetail: "johndoe@email.com"
                                    )
                                    .background(NavigationLink("", destination: EmailView()).opacity(0))
                                    
                                    // Password Button with navigation
                                    SettingButtonWithAccountDetailView(
                                        buttonText: "Password",
                                        accountDetail: "Change Password"
                                    )
                                    .background(
                                        NavigationLink(
                                            "",
                                            destination: PasswordView(appController: appController, settingsViewModel: viewModel)
                                        ).opacity(0)
                                    )
                                }
                                .listRowSeparator(.hidden)
                                .padding(.top, -10)
                                
                                // Manage Account Section
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
                                                viewModel.resetUserJournal(userId: profile.userId)
                                            }
                                        }
                                    } message: {
                                        Text("Are you sure you want to clear all entries and restart? This action cannot be undone!")
                                    }
                                    .alert("Failed to Reset", isPresented: $viewModel.isShowingJournalResetFailedAlert) {
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
                                            viewModel.signOut {
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
                                            viewModel.signOut {
                                                self.appController.loadedUserProfile = nil
                                                self.appController.viewSignUpFlag = false
                                                self.appController.loggedIn = false
                                            }
                                        }
                                    } message: {
                                        Text("Are you sure you want to delete your account? This action cannot be undone!")
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .padding(.top, -10)
                                
                                // Location Section
                                Section(header:
                                            Text("Location")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .frame(height: 0, alignment: .center)
                                    .padding(.leading, 25)
                                ) {
                                    // Share Location Toggle
                                    HStack {
                                        SettingButtonWithToggleView(
                                            buttonText: "Use My Location",
                                            isToggleOn: $isLocationShared
                                        )
                                    }
                                    
                                    // Custom Location Button
                                    ZStack {
                                        if !isLocationShared {
                                            // Navigate to CustomLocationView when toggle is off
                                            CustomLocationButtonView(isLocationShared: $isLocationShared)
                                                .background(NavigationLink("", destination: CustomLocationView()).opacity(0))
                                        } else {
                                            // Static button when toggle is on
                                            CustomLocationButtonView(isLocationShared: $isLocationShared)
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .padding(.top, -10)
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                            .listRowSpacing(0)
                        }
                    }
                }
                
                if viewModel.isResettingJournal {
                    ProgressBufferView(backgroundColor: Color(.systemGray4)) {
                        Text("Please wait...")
                    }
                }
                
            }
        }
    }
}

#Preview {
    SettingView(appController: AppViewController())
}
