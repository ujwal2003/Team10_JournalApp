//
//  SettingButtonWithAccountDetailView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 11/30/24.
//

import SwiftUI

struct SettingButtonWithAccountDetailView: View {
    var buttonText: String // Main button text
    var accountDetail: String // Secondary detail displayed next to the button text
    var dummyDisplayName: String = "JohnDoe" // Placeholder display name
    var dummyEmail: String = "johndoe@test.com" // Placeholder email

    var body: some View {
        ZStack {
            // Button background with shadow
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 50)
                .background(Color.rgb(221, 237, 240))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            
            HStack {
                // Main button text
                Text(buttonText)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Account detail and navigation arrow
                HStack(spacing: 20) {
                    Text(accountDetail)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.black.opacity(0.5))
                    
                    Text(">")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}
