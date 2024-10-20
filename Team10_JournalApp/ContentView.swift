//
//  ContentView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/6/24.
//

import SwiftUI

enum AppTab {
    case Home; case Journal; case Friends; case Settings
}

struct ContentView: View {
    @State var selectedTab: AppTab = .Home
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(AppTab.Home)
                
                Text("Journal View")
                    .tabItem {
                        Image(systemName: "book")
                        Text("Journal")
                    }.tag(AppTab.Journal)
                
                Text("Friends View")
                    .tabItem {
                        Image(systemName: "person.3")
                        Text("Friends")
                    }.tag(AppTab.Friends)
                
                Text("Settings View")
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }.tag(AppTab.Settings)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDisplayName("Portrait")

        ContentView().previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Landscape Left")
    }
}
