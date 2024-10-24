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
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .padding(.leading, 10)
                                ) {
                                    Button(action: {
                                        isShowingResetAlert = true
                                    }) {
                                        Text("Reset Journal")
                                            .font(Font.custom("Qanelas Soft DEMO", size: 20).weight(.medium))
                                            .foregroundColor(.black)
                                            .padding(.leading, 10)
                                    }
                                    .alert("Reset Journal?", isPresented: $isShowingResetAlert) {
                                        Button("No") { }
                                        Button("Yes") { }
                                    } message: {
                                        Text("Are you sure you want to clear all entries and restart? This action cannot be undone!")
                                    }
                                    
                                    NavigationLink(destination: ChangeCredentialsView()) {
                                        Text("Change Account Credentials")
                                            .font(Font.custom("Qanelas Soft DEMO", size: 20).weight(.medium))
                                            .foregroundColor(.black)
                                            .padding(.leading, 10)
                                    }
                                    
                                    Button(action: {
                                        isShowingSignOutAlert = true
                                    }) {
                                        Text("Sign Out")
                                            .font(Font.custom("Qanelas Soft DEMO", size: 20).weight(.medium))
                                            .foregroundColor(.black)
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
                                
                                Section(header:
                                            Text("Location")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                                    .textCase(nil)
                                    .padding(.leading, 10)
                                ) {
                                    Toggle(isOn: $isLocationShared) {
                                                                    Text("Share Location")
                                                                        .font(Font.custom("Qanelas Soft DEMO", size: 20).weight(.medium))
                                                                        .foregroundColor(.black)
                                                                        .padding(.leading, 10)
                                                                }
                                                                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.09, green: 0.28, blue: 0.39)))
                                    
                                    NavigationLink(destination: ToggleCustomLocationView()) {
                                        Text("Toggle Custom Location")
                                            .font(Font.custom("Qanelas Soft DEMO", size: 20).weight(.medium))
                                            .foregroundColor(.black)
                                            .padding(.leading, 10)
                                    }
                                }
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
