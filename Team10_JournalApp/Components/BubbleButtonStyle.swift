//
//  TestButtonStyle.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/25/24.
//

import SwiftUI

struct BubbleButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var textColor: Color
    var radius: CGFloat = 10
    var shadowRadius: CGFloat = 5

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .shadow(radius: shadowRadius)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
