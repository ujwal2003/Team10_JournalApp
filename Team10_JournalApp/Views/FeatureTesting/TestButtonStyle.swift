//
//  TestButtonStyle.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/25/24.
//

import SwiftUI

struct TestButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var textColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .shadow(radius: 5)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
