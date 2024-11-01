//
//  ContentView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/6/24.
//

import SwiftUI

enum AppTab {
    case Home; case Journal; case Friends; case Settings
    case Exepriments //! FOR TESTING
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
                
                JournalEntryView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Journal")
                    }.tag(AppTab.Journal)
                
                FriendsView()
                    .tabItem {
                        Image(systemName: "person.3")
                        Text("Friends")
                    }.tag(AppTab.Friends)
                
                SettingView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }.tag(AppTab.Settings)
                
                //! FOR TESTING
                ExperimentsTestView()
                    .tabItem {
                        Image(systemName: "testtube.2")
                        Text("Experiments")
                    }.tag(AppTab.Exepriments)
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
