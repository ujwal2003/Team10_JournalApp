//
//  SignInView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/8/24.
//

import SwiftUI

struct Constants {
    static let LabelsPrimary: Color = .black
    static let MiscellaneousTextFieldBG: Color = .white
}

struct SignInView: View {
    @ObservedObject var appController: AppViewController
    @StateObject var viewModel = SignInViewModel()
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?

    @FocusState private var focusedField: SignInField?
    enum SignInField {
        case username; case password
    }

    var body: some View {
        let orientation = DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)

        NavigationStack {
            AppLayoutContainer(height: 10.0) {
                // Title content: Displays "Hello!" and subtitle
                VStack(alignment: .leading, spacing: 10) {
                    Text("Hello!")
                        .font(.system(size: 40.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 55.0)
                        .foregroundStyle(Color.black)

                    Text("Log in to CatchUp.")
                        .font(.system(size: 20.0).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 55.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical, DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
                    .isLandscape(device: .iPhone) ? 10 : 65)

            } containerContent: {
                // Container content with ScrollView in horizontal orientation
                Group {
                    if orientation.isLandscape(device: .iPhone) || orientation.isLandscape(device: .iPhonePlusOrMax) || orientation.isLandscape(device: .iPadFull) {
                        ScrollView {
                            mainContent
                                .padding(.top, 20)
                        }
                        .scrollIndicators(.never) // Hides the scroll indicators
                    } else {
                        mainContent
                    }
                }
                .onTapGesture {
                    focusedField = nil // Dismisses the keyboard on tap
                }
                
                if viewModel.isLoading {
                    ProgressBufferView(backgroundColor: Color(.systemGray4).opacity(0.90)) {
                        Text("Loading...")
                    }
                }
            }
        }
        .onSubmit {
            // Handles keyboard navigation between fields
            switch focusedField {
                case .username:
                    focusedField = .password
                default:
                    focusedField = nil
            }
        }
    }

    /// Main content for the container
    private var mainContent: some View {
        VStack {
            // Username and password input fields
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
                            .submitLabel(.done)
                    }
                }
            }
            .padding([.bottom], 40)

            // MARK: Sign in and sign up buttons
            VStack(spacing: DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
                .isLandscape(device: .iPhone) ? 20 : 91) {
                let emptyFields = viewModel.email.isEmpty || viewModel.password.isEmpty

                // Sign In button
                Button(action: {
                    viewModel.signIn { userProfile in
                        self.appController.loadedUserProfile = userProfile
                        self.appController.loggedIn = true
                    }
                }) {
                    Text("Sign In")
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
                .disabled(emptyFields)
                .alert("Failed to Sign In", isPresented: $viewModel.isShowingSignInFailedAlert) {
                    Button("Ok") {
                        viewModel.password = ""
                    }
                } message: {
                    Text("The account '\(viewModel.email)' was not found. The credentials are incorrect or the account does not exist.")
                }

                // Sign Up button
                Button(action: {
                    self.appController.viewSignUpFlag = true
                }) {
                    Text("Don’t have an account? ")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Constants.LabelsPrimary) +
                    Text("Sign Up")
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
