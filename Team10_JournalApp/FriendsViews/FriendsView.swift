//
//  FriendsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/22/24.
//

import SwiftUI

enum FriendSelectionContent {
    case Friends
    case Requests
    case Invitations
}

struct FriendsView: View {
    @State var selectedContent: FriendSelectionContent = .Friends
    @State var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            DefaultRectContainer(title: .init(text: "Friends", fontSize: 30),
                                 subtitle: .init(text: "", fontSize: 20)) {
                
                Picker("", selection: $selectedContent) {
                    Text("Friends").tag(FriendSelectionContent.Friends)
                    Text("Requests").tag(FriendSelectionContent.Requests)
                    Text("Invites").tag(FriendSelectionContent.Invitations)
                }
                .pickerStyle(.segmented)
                .padding()
                
                SearchBarView(searchText: $searchQuery)
                
            }
        }
    }
}

#Preview {
    FriendsView()
}
