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
    @State private var path = NavigationPath()
    
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
                    Picker("Friends Selection Picker", selection: $viewModel.selectedContent) {
                        Text("Friends").tag(FriendSelectionContent.Friends)
                        Text("Requests").tag(FriendSelectionContent.Requests)
                        Text("Invitations").tag(FriendSelectionContent.Invitations)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    SearchBarView(searchText: $viewModel.searchQuery)
                    
                    let isViewingCurrFriends = viewModel.selectedContent == .Friends
                    HeadingToolBarView(
                        contentTitle: viewModel.selectedContent.contentTitle,
                        isEditVisible: isViewingCurrFriends,
                        isEditing: isEditing,
                        onEditClick: { isEditing.toggle() },
                        onAddIconClick: { viewModel.isAddFriendSheetVisible.toggle() }
                    ) // TODO: add sheet for adding friends
                    
                    List {
                        if viewModel.isSelectedContentListEmpty() {
                            HStack {
                                Spacer()
                                Text("No Content Found").opacity(0.5)
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                            
                        } else {
                            viewModel.getContentList()
                        }
                    }
                    .listStyle(.plain)
                    .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
                    
                }
            }
            .task {
                // FIXME: use actual db stuff here
                viewModel.friends = [
                    .init(
                        userID: "rweiuruiwueriw8927381ia",
                          email: "test",
                        displayName: "test"
                    )
                ]
                
                viewModel.friendRequests = [
                    .init(
                        userID: "sdsdfsdfdsf987983467538",
                          email: "test",
                        displayName: "test"
                    )
                ]
                
                viewModel.friendInvites = [
                    .init(
                        userID: "wegriuweguqaegr83427652983",
                          email: "test",
                        displayName: "test"
                    )
                ]
            }
            
        }
    }
}

#Preview {
    AppTabMockContainerView(previewTab: .Friends) {
        FriendsView()
    }
}
