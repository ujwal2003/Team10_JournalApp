//
//  SignUpView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/20/24.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var appController: AppViewController
    @StateObject var viewModel = SignUpViewModel()
    
    @FocusState private var focusedField: SignUpField?
    enum SignUpField {
        case username; case password; case password_confirm
    }
    
    var body: some View {
        
        NavigationStack {
            DefaultRectContainer(
                title: .init(text: "Sign Up", fontSize: 40.0),
                subtitle: .init(text: "Create an account to CatchUp!", fontSize: 20.0),
                minifiedFrame: true,
                headLeftAlign: .signInAlign,
                headTopAlign: .topCentralAlign
            ) {
                VStack {
                    Spacer()
                    // MARK: Username and password inputs
                    Grid(horizontalSpacing: 10, verticalSpacing: 21) {
                        GridRow {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 315, height: 52)
                                    .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                                    .cornerRadius(100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                                    )
                                
                                TextField("Email", text: $viewModel.email)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .padding(.horizontal, 5)
                                    .frame(width: 295, height: 52)
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .username)
                                    .submitLabel(.next)
                            }
                        }
                        
                        GridRow {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 315, height: 52)
                                    .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                                    .cornerRadius(100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                                    )
                                
                                SecureField("Password", text: $viewModel.password)
                                    .autocorrectionDisabled()
                                    .padding(.horizontal, 5)
                                    .frame(width: 295, height: 52)
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.next)
                            }
                        }
                        
                        GridRow {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 315, height: 52)
                                    .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                                    .cornerRadius(100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                                    )
                                
                                SecureField("Retype Password", text: $viewModel.retypedPassword)
                                    .autocorrectionDisabled()
                                    .padding(.horizontal, 5)
                                    .frame(width: 295, height: 52)
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .password_confirm)
                                    .submitLabel(.done)
                            }
                        }
                        
                    }
                    .padding([.bottom], 40)

                    // MARK: Sign in and sign up buttons
                    VStack(spacing: 91) {
                        let emptyFields = viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.retypedPassword.isEmpty
                        let nonMatchingPasswords = viewModel.password != viewModel.retypedPassword
                        
                        VStack(spacing: 0.0) {
                            if nonMatchingPasswords {
                                Text("Password fields must match.")
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .foregroundStyle(.black)
                                    .padding()
                            }
                            
                            Button(action: {
                                viewModel.signUp { newUser in
                                    self.appController.loadedUserProfile = newUser
                                    self.appController.loggedIn = true
                                }
                            }) {
                                Text("Sign Up")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 315, height: 52)
                                    .background(
                                        RoundedRectangle(cornerRadius: 100)
                                            .fill(Color(red: 0.09, green: 0.28, blue: 0.39))
                                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(emptyFields || nonMatchingPasswords)
                            .alert("Sign Up Failed", isPresented: $viewModel.isSignUpFailedAlertShowing) {
                                Button("Try Again") {}
                            } message: {
                                Text("Failed to sign up new user, please try again.")
                            }

                            
                        }

                        Button(action: {
                            self.appController.viewSignUpFlag = false
                        }) {
                            Text("Already have an account? ")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Constants.LabelsPrimary) +
                            Text("Sign In")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Constants.LabelsPrimary)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 275, alignment: .topLeading)

                    }
                    .padding([.bottom], 80)
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            
        }
        .onSubmit {
            switch focusedField {
                case .username:
                    focusedField = .password
                case .password:
                    focusedField = .password_confirm
                default:
                    focusedField = nil
            }
        }
    }
}
