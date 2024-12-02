//
//  ProgressBufferView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/1/24.
//

import SwiftUI

struct ProgressBufferView<Content: View>: View {
    let backgroundColor: Color
    let content: Content
    
    init(backgroundColor: Color = Color.gray.opacity(0.18), @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        ProgressView() {
            content
        }
        .controlSize(.extraLarge)
        .padding(40)
        .tint(.gray)
        .background(backgroundColor)
        .clipShape(RoundedCorner(radius: 5.0))
    }
}

#Preview {
    ProgressBufferView {
        Text("Loading...").padding(.top)
    }
}
