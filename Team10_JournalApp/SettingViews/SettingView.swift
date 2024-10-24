//
//  SettingView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/22/24.
//

import SwiftUI

struct SettingView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isShowingResetAlert: Bool = false
    @State private var isShowingSignOutAlert: Bool = false
    @State private var isSignedOut: Bool = false
    @State private var isLocationShared: Bool = false
    @State private var isNavigating = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            DefaultRectContainer(
                title: .init(text: "Settings", fontSize: 40.0),
                subtitle: .init(text: "", fontSize: 20.0),
                minifiedFrame: true,
                headLeftAlign: .signInAlign,
                headTopAlign: .topCentralAlign
            ) {
                VStack {
                    NavigationStack {
                        VStack {
                            List {
                                Section(header:
                                            Text("Account")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .padding(.leading, 10)
                                ) {
                                    Button(action: {
                                        isShowingResetAlert = true
                                    }) {
                                        SettingButtonView(buttonText: "Reset Journal", isCheckInVisible: true)
                                    .padding(.leading, 10)
                                    }
                                    .alert("Reset Journal?", isPresented: $isShowingResetAlert) {
                                        Button("No") { }
                                        Button("Yes") { }
                                    } message: {
                                        Text("Are you sure you want to clear all entries and restart? This action cannot be undone!")
                                    }
                                    ZStack {
                                        NavigationLink(destination: ChangeCredentialsView()) {
                                                                    EmptyView()
                                                                }
                                                                .opacity(0)
                                        SettingButtonView(buttonText: "Change Account Credentials", isCheckInVisible: true)
                                            .padding(.leading, 10)
                                    }
                                    .navigationBarBackButtonHidden(true)
                                    
                                    Button(action: {
                                        isShowingSignOutAlert = true
                                    }) {
                                        SettingButtonView(buttonText: "Sign Out", isCheckInVisible: true)
                                    .padding(.leading, 10)
                                    }
                                    .alert("Sign Out?", isPresented: $isShowingSignOutAlert) {
                                        Button("No") { }
                                        Button("Yes") {
                                            isSignedOut = true
                                        }
                                    } message: {
                                        Text("Are you sure you want to sign out?")
                                    }
                                }
                                .listRowSeparator(.hidden)
                                
                                Section(header:
                                            Text("Location")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .padding(.leading, 10)
                                ) {
                                    ZStack {
                                        Toggle(isOn: $isLocationShared) {
                                            SettingButtonView(buttonText: "Share Location", isCheckInVisible: true)
                                        }
                                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.09, green: 0.28, blue: 0.39)))
                                        .padding(.trailing, 10)
                                    }
                                    .padding(.leading, 10)
                                    
                                    ZStack {
                                        NavigationLink(destination: ToggleCustomLocationView()) {
                                                                    EmptyView()
                                                                }
                                                                .opacity(0)
                                        SettingButtonView(buttonText: "Toggle Custom Location", isCheckInVisible: true)
                                            .padding(.leading, 10)
                                    }
                                    
                                }
                                .listRowSeparator(.hidden)
                            }
                            .padding(.trailing, 30)
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                            
                            
                        }
                        .fullScreenCover(isPresented: $isSignedOut) {
                            SignInView()
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
    SettingView()
}
