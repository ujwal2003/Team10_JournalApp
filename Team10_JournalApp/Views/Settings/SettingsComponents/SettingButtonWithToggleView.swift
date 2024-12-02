//
//  SettingButtonWithToggleView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 11/30/24.
//

import SwiftUI

struct SettingButtonWithToggleView: View {
    var buttonText: String // Text displayed on the button
    @Binding var isToggleOn: Bool // Toggle state binding

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
                // Button text
                Text(buttonText)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Custom toggle switch
                Toggle("", isOn: $isToggleOn)
                    .toggleStyle(CustomToggleStyle())
            }
            .padding(.horizontal, 20) // Padding for alignment
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            // Custom toggle design
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color(red: 0.09, green: 0.28, blue: 0.39) : Color.gray)
                .frame(width: 60, height: 30) // Adjust dimensions for the toggle
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 25, height: 25)
                        .offset(x: configuration.isOn ? 15 : -15) // Circle position based on toggle state
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle() // Update toggle state on tap
                }
        }
    }
}
