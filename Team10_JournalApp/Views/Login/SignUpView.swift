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
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?

    @FocusState private var focusedField: SignUpField?
    enum SignUpField {
        case username; case password; case password_confirm
    }

    var body: some View {
        let orientation = DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        NavigationStack {
            AppLayoutContainer(height: 10.0) {
                // Title content: Display "Sign Up" and subtitle
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sign Up")
                        .font(.system(size: 40.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 55.0)
                        .foregroundStyle(Color.black)

                    Text("Create an account to CatchUp!")
                        .font(.system(size: 20.0).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 55.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical, DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
                    .isLandscape(device: .iPhone) ? 10 : 65)
            } containerContent: {
                // Container content with conditional ScrollView in horizontal orientation
                Group {
                    if orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPadFull) {
                        ScrollView {
                            mainContent
                                .padding()
                        }
                        .scrollIndicators(.never)
                    } else {
                        mainContent
                    }
                }
                .onTapGesture {
                    focusedField = nil // Dismiss keyboard when tapping outside
                }
                
                ProgressBufferView(backgroundColor: Color(.systemGray4).opacity(0.90)) {
                    Text("Loading...")
                }
                
            }
        }
        .onSubmit {
            // Navigate between fields or dismiss keyboard
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

    /// Main content for the container
    private var mainContent: some View {
        VStack {
            Spacer()
            
            // MARK: Username and password inputs
            Grid(horizontalSpacing: 10, verticalSpacing: 21) {
                // Email input field
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
                
                // Password input field
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
                
                // Retype Password input field
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
            .padding([.bottom], DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
                .isLandscape(device: .iPhone) ? 20 : 40)

            // Sign up and sign in buttons
            VStack(spacing: DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
                .isLandscape(device: .iPhone) ? 20 : 91) {
                let emptyFields = viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.retypedPassword.isEmpty
                let nonMatchingPasswords = viewModel.password != viewModel.retypedPassword
                
                // Sign Up button with validation
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

                // Navigate to Sign In screen
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
}
