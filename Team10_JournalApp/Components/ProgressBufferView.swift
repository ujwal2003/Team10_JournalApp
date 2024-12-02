//
//  ProgressBufferView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/1/24.
//

import SwiftUI

struct ProgressBufferView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ProgressView() {
            content
        }
        .controlSize(.extraLarge)
        .padding(40)
        .tint(.gray)
        .background(Color.gray.opacity(0.18))
        .clipShape(RoundedCorner(radius: 5.0))
    }
}

#Preview {
    ProgressBufferView {
        Text("Loading...").padding(.top)
    }
}
