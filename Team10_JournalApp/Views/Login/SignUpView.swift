//
//  SignUpView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/20/24.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var retypePassword: String = ""
    
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
                                
                                SecureField("Retype Password", text: $retypePassword)
                                    .padding(.horizontal, 5)
                                    .frame(width: 295, height: 52)
                                    .foregroundColor(.black)
                                    .focused($focusedField, equals: .password_confirm)
                            }
                        }
                        
                    }
                    .padding([.bottom], 40)

                    // MARK: Sign in and sign up buttons
                    VStack(spacing: 91) {
                        NavigationLink(destination: ContentView()) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 315, height: 52)
                                    .background(Color(red: 0.09, green: 0.28, blue: 0.39))
                                    .cornerRadius(100)
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                
                                Text("Sign Up")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        NavigationLink(destination: SignInView()) {
                            ZStack {
                                Text("Already have an account? ")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Constants.LabelsPrimary) +
                                Text("Sign In")
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

#Preview {
    SignUpView()
}
