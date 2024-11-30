//
//  SettingButtonWithToggleView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 11/30/24.
//

import SwiftUI

struct SettingButtonWithToggleView: View {
    var buttonText: String
        @Binding var isToggleOn: Bool
        
        var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 370, height: 49)
                    .background(Color.hex("9BBEC8").opacity(0.28))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                
                HStack {
                    Text(buttonText)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Spacer()
                    Toggle("", isOn: $isToggleOn)
                        .toggleStyle(CustomToggleStyle())
                    
                }
                .padding(.horizontal, 20) // Padding for alignment
            }
            .frame(width: 370, height: 49)
        }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color(red: 0.09, green: 0.28, blue: 0.39) : Color.gray)
                .frame(width: 60, height: 30) // Adjust width and height to make it longer
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 25, height: 25)
                        .offset(x: configuration.isOn ? 15 : -15) // Move circle based on state
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
