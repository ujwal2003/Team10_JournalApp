//
//  FriendsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/22/24.
//

import SwiftUI

struct FriendsView: View {
    @StateObject var viewModel = FriendsViewModel()
    @Environment(\.editMode) var editMode
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            AppLayoutContainer(height: 0.0) {
                VStack {
                    Text("Friends")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
                }
                .padding()
                
            } containerContent: {
                VStack {
                    Picker("", selection: $viewModel.selectedContent) {
                        Text("Friends").tag(FriendSelectionContent.Friends)
                        Text("Requests").tag(FriendSelectionContent.Requests)
                        Text("Invitations").tag(FriendSelectionContent.Invitations)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    SearchBarView(searchText: $viewModel.searchQuery)
                    
                    HeadingToolBarView(contentTitle: viewModel.selectedContent.contentTitle,
                                       isEditVisible: viewModel.isEditButtonVisible(),
                                       isEditing: isEditing,
                                       onEditClick: { isEditing.toggle() },
                                       onAddIconClick: { viewModel.isAddFriendSheetVisible.toggle() })
                    .sheet(isPresented: $viewModel.isAddFriendSheetVisible) {
                        AddFriendView(friendsViewModel: viewModel)
                    }
                    
                    List {
                        ForEach(viewModel.getFilteredFriends(), id: \.self) { friend in
                            FriendListRowView(itemName: friend,
                                              itemContent: .emptyContent
                            )
                        }
                    }
                    .listStyle(.plain)
                    
                }
            }
        }
    }
}
