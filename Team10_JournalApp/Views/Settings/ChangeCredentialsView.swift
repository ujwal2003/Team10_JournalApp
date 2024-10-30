//
//  ChangeCredentialsView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/23/24.
//

import SwiftUI

struct ChangeCredentialsView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var retypePassword: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        DefaultRectContainer(
            title: .init(text: "Change Credentials", fontSize: 40.0),
            subtitle: .init(text: "", fontSize: 20.0),
            minifiedFrame: false,
            headLeftAlign: .signInAlign,
            headTopAlign: .topCentralAlign
        ) {
            
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
                    }
                }
            }
        }
        VStack(spacing: 91) {
            NavigationLink(destination: SettingView()) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 315, height: 52)
                        .background(Color(red: 0.09, green: 0.28, blue: 0.39))
                        .cornerRadius(100)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    
                    Text("Save")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        
        .padding([.bottom], 160)
    }
}

#Preview {
    ChangeCredentialsView()
}
