//
//  UserContentView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/2/24.
//

import SwiftUI

enum AppTab: Hashable {
    case Home; case Journal; case Friends; case Settings
}

struct UserContentView: View {
    @ObservedObject var appController: AppViewController
    @State var selectedTab: AppTab = .Home
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house", value: .Home) {
                    HomeView(appController: appController)
                }
                
                Tab("Journal", systemImage: "book", value: .Journal) {
                    JournalEntryView()
                }
                
                Tab("Friends", systemImage: "person.3", value: .Friends) {
                    FriendsView()
                }
//                .badge(2)
                
                Tab("Settings", systemImage: "gear", value: .Settings) {
                    SettingView(appController: appController)
                }
            }
        }
        
    }
}
