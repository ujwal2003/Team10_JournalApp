//
//  SettingButtonView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/24/24.
//

import SwiftUI

struct SettingButtonView: View {
    var buttonText: String
    var isCheckInVisible: Bool = true
    
    var body: some View {
        ZStack() {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 370, height: 49)
              .background(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.28))
              .cornerRadius(15)
              .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            HStack {
                Text(buttonText)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Spacer()
                Text(">")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 370, height: 49)
    }
}
