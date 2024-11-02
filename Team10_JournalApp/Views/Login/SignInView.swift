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
    @ObservedObject var appController: AppController
    
    @State private var username: String = ""
    @State private var password: String = ""
    
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
                                
                                TextField("Username", text: $username)
                                    .padding(.horizontal, 5)
                                    .frame(width: 295, height: 52)
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .username)
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
                                
                                SecureField("Password", text: $password)
                                    .padding(.horizontal, 5)
                                    .frame(width: 295, height: 52)
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .password)
                            }
                        }
                    }
                    .padding([.bottom], 40)

                    // MARK: Sign in and sign up buttons
                    VStack(spacing: 91) {
                        Group {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 315, height: 52)
                                    .background(Color(red: 0.09, green: 0.28, blue: 0.39))
                                    .cornerRadius(100)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                
                                Text("Sign In")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            self.appController.loggedIn = true
                        }
                        

                        NavigationLink(destination: SignUpView().preferredColorScheme(.light)) {
                            ZStack {
                                Text("Don’t have an account? ")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Constants.LabelsPrimary) +
                                Text("Sign Up")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Constants.LabelsPrimary)
                            }
                            .frame(width: 275, alignment: .topLeading)
                        }
                        .navigationBarBackButtonHidden(true)
                    }
                    .padding([.bottom], 80)
                }
                
            }
            .onTapGesture {
                focusedField = nil
            }
            
            
        }
    }
}
