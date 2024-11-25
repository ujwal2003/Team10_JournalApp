//
//  AppTabMockContainerView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import SwiftUI

struct AppTabMockContainerView<Content: View>: View {
    var previewTab: AppTab
    let content: Content
    
    let selectedPreview: AppTab
    
    init(previewTab: AppTab, @ViewBuilder content: () -> Content) {
        self.previewTab = previewTab
        self.content = content()
        
        self.selectedPreview = previewTab
    }
    
    var body: some View {
        TabView(selection: .constant(previewTab)) {
            Tab("Home", systemImage: "house", value: .Home) {
                if selectedPreview == .Home {
                    content
                } else {
                    Text("MOCK PREVIEW")
                }
            }
            
            Tab("Journal", systemImage: "book", value: .Journal) {
                if selectedPreview == .Journal {
                    content
                } else {
                    Text("MOCK PREVIEW")
                }
            }
            
            Tab("Friends", systemImage: "person.3", value: .Friends) {
                if selectedPreview == .Friends {
                    content
                } else {
                    Text("MOCK PREVIEW")
                }
            }
            
            Tab("Settings", systemImage: "gear", value: .Settings) {
                if selectedPreview == .Settings {
                    content
                } else {
                    Text("MOCK PREVIEW")
                }
            }
        }
        
    }
}

#Preview {
    AppTabMockContainerView(previewTab: .Home) {
        Text("Testing UI")
    }
}
