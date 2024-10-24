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
        HStack {
            Text(buttonText)
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                .fontWeight(.medium)
            
            Spacer()
        }
        .frame(width: FRIENDS_ROW_WIDTH, height: 20)
        .padding()
        .background(Color.rgb(221, 237, 240))
        .clipShape(RoundedCorner(radius: 15))
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}
