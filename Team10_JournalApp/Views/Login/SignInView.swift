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
    
    @FocusState private var focusedField: SignInField?
    enum SignInField {
        case username; case password
    }
    
    var body: some View {
        NavigationStack {
            DefaultRectContainer(
                title: .init(text: "Hello!", fontSize: 40.0),
                subtitle: .init(text: "Log in to CatchUp.", fontSize: 20.0),
                minifiedFrame: true,
                headLeftAlign: .signInAlign,
                headTopAlign: .topCentralAlign
            ) {
                VStack {
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
                                    .submitLabel(.done)
                            }
                        }
                    }
                    .padding([.bottom], 40)

                    // MARK: Sign in and sign up buttons
                    VStack(spacing: 91) {
                        let emptyFields = viewModel.email.isEmpty || viewModel.password.isEmpty
                        
                        Button(action: {
                            viewModel.signIn()
                            appController.certifyAuthStatus()
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
            .onTapGesture {
                focusedField = nil
            }
            
            
        }
        .onSubmit {
            switch focusedField {
                case .username:
                    focusedField = .password
                default:
                    focusedField = nil
            }
        }
    }
}
