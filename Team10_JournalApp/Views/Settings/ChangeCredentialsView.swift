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
        NavigationStack {
            AppLayoutContainer(height: 20.0) {
                // Title Content
                VStack(alignment: .leading, spacing: 10) {
                    Text("Change Credentials")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                    
                    Text("") // Subtitle placeholder if needed
                        .font(.system(size: 20).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                // Main Content
                VStack(spacing: 21) {
                    Spacer()
                    // Username Field
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
                    
                    // Password Field
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
                    
                    // Retype Password Field
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
                    
                    // Save Button
                    Spacer()
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
                    .onTapGesture {
                        dismiss()
                    }
                    .padding(.top, 50)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 160)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChangeCredentialsView()
}
