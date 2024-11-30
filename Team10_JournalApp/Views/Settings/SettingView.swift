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
                // Title Content
                VStack(alignment: .leading, spacing: 10) {
                    Text("Settings")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                // Main Content
                VStack {
                    NavigationStack {
                        VStack {
                            List {
                                Section(header:
                                            Text("Account Details")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .frame(height: 0, alignment: .center)
                                    .padding(.leading, 25)
                                ) {
                                    Button(action: {
                                        isShowingChangeCredentialsAlert = true
                                    }) {
                                        SettingButtonWithAccountDetailView(buttonText: "Display Name", accountDetail: "JohnDoe", isCheckInVisible: true)
                                    }
                                    
                                    Button(action: {
                                        isShowingChangeCredentialsAlert = true
                                    }) {
                                        SettingButtonWithAccountDetailView(buttonText: "Email", accountDetail: "johndoe@email.com", isCheckInVisible: true)
                                    }
                                    
                                    Button(action: {
                                        isShowingChangeCredentialsAlert = true
                                    }) {
                                        SettingButtonWithAccountDetailView(buttonText: "Password", accountDetail: "Change Password", isCheckInVisible: true)
                                    }
                                    
                                }
                                .listRowSeparator(.hidden)
                                .padding(.top, -10)
                                
                                Section(header:
                                            Text("Manage Account")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .frame(height: 0, alignment: .center)
                                    .padding(.leading, 25)
                                ) {
                                    Button(action: {
                                        isShowingChangeCredentialsAlert = true
                                    }) {
                                        SettingButtonView(buttonText: "Reset Journal", isCheckInVisible: true)
                                    }
                                    .alert("Reset Journal?", isPresented: $isShowingChangeCredentialsAlert) {
                                        Button("No") { }
                                        Button("Yes") { }
                                    } message: {
                                        Text("Are you sure you want to clear all entries and restart? This action cannot be undone!")
                                    }
                                    
                                    Button(action: {
                                        isShowingSignOutAlert = true
                                    }) {
                                        SettingButtonView(buttonText: "Sign Out", isCheckInVisible: true)
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
                                    
                                    Button(action: {
                                        isShowingDeleteAccountAlert = true
                                    }) {
                                        SettingButtonView(buttonText: "Delete Account", isCheckInVisible: true)
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
                                
                                Section(header:
                                            Text("Location")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .frame(height: 0, alignment: .center)
                                    .padding(.leading, 25)
                                ) {
                                    HStack {
                                        SettingButtonWithToggleView(
                                            buttonText: "Share Location",
                                            isToggleOn: $isLocationShared
                                        )
                                    }
                                    .frame(width: 370, height: 49)
                                    
                                    ZStack() {
                                        NavigationLink(destination: ToggleCustomLocationView()) {
                                            EmptyView()
                                        }
                                        .opacity(0)
                                        
                                        if !isLocationShared {
                                                NavigationLink(destination: ToggleCustomLocationView()) {
                                                    CustomLocationButtonView(isLocationShared: $isLocationShared)
                                                }
                                            } else {
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
            }
        }
    }
}


struct ToggleCustomLocationView: View {
    var body: some View {
        Text("Coming soon!")
    }
}

#Preview {
    SettingView(appController: AppViewController())
}
