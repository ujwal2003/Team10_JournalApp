//
//  ActionButtonView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/20/24.
//

import SwiftUI

struct ActionButtonView: View {
    
    var isDisabled: Bool
    var onClick: () -> Void
    
    var body: some View {
        
        Button(action: { onClick() }, label: {
            Text("Recommended  actions for today")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal)
                .padding(.vertical, 8.0)
        })
        .disabled(isDisabled)
        .frame(width: 190)
        .background(Color(red: 0.09, green: 0.28, blue: 0.39))
        .foregroundStyle(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .opacity(isDisabled ? 0.4 : 1)
        
    }
}
