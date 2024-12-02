//
//  SettingButtonView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/24/24.
//

import SwiftUI

struct SettingButtonView: View {
    var buttonText: String // Text displayed on the button
    var isDeleteButton: Bool = false // Indicates if the button is a delete action

    var body: some View {
        ZStack {
            // Button background with shadow
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370, height: 49)
                .background(Color.rgb(221, 237, 240))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            
            HStack {
                // Button text with conditional styling
                Text(buttonText)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(isDeleteButton ? .red : .black) // Red for delete buttons
                
                Spacer()

                // Arrow indicating navigation
                Text(">")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 370, height: 49)
    }
}
