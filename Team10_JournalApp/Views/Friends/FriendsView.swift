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
                    Picker("", selection: $viewModel.selectedContent) {
                        Text("Friends").tag(FriendSelectionContent.Friends)
                        Text("Requests").tag(FriendSelectionContent.Requests)
                        Text("Invitations").tag(FriendSelectionContent.Invitations)
                    }
                    .pickerStyle(.segmented)
                    .padding(.top, 5.0)
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
                        switch viewModel.selectedContent {
                            case .Friends:
                                ForEach(viewModel.getFilteredFriends(), id: \.self) { friendUserName in
                                    FriendListRowView(itemName: friendUserName,
                                                      itemContent: .checkIn)
                                    .background(
                                        NavigationLink(
                                            "",
                                            destination: FriendCheckInView(friendName: friendUserName,
                                                                           friendsViewModel: viewModel)
                                        ).opacity(0)
                                    )
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete(perform: viewModel.delete(at:))
                                
                            case .Requests:
                                ForEach(viewModel.getFilteredRequests(), id: \.self) { requestUserName in
                                    FriendListRowView(
                                        itemName: requestUserName,
                                        itemContent: .requestButtons(
                                            onAccept: {
                                                Task {
                                                    await viewModel.acceptFriendRequest(username: requestUserName)
                                                }
                                            },
                                            onReject: {
                                                Task {
                                                    await viewModel.rejectFriendRequest(username: requestUserName)
                                                }
                                            }
                                        )
                                    )
                                }
                                
                            case .Invitations:
                                ForEach(viewModel.getFilteredInvitations(), id: \.self) { inviteUserName in
                                    FriendListRowView(
                                        itemName: inviteUserName,
                                        itemContent: .inviteRescindButton(
                                            onRevoke: {
                                                Task {
                                                    await viewModel.revokeFriendInvite(username: inviteUserName)
                                                }
                                            }
                                        )
                                    )
                                }
                        }
                    }
                    .listStyle(.plain)
                    .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
                    
                }
            }
        }
    }
}

#Preview {
    AppTabMockContainerView(previewTab: .Friends) {
        FriendsView()
    }
}
