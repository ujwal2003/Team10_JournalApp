//
//  FriendsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/22/24.
//

import SwiftUI

struct HeadingToolBarView: View {
    var contentTitle: String
    var isEditVisible: Bool
    var isEditing: Bool
    
    var onEditClick: () -> Void
    var onAddIconClick: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(contentTitle)
                .font(.system(size: 24))
                .fontWeight(.semibold)
            
            Spacer()
            
            if isEditVisible {
                Button(action: { onEditClick() }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                }
            }
            
            Button(action: { onAddIconClick() }) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
        }
        .padding()
        .padding(.horizontal)
    }
}

struct FriendsView: View {
    @StateObject var viewModel = FriendsViewModel()
    @Environment(\.editMode) var editMode
    
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            DefaultRectContainer(title: .init(text: "Friends", fontSize: 30),
                                 subtitle: .init(text: "", fontSize: 20)) {
                
                VStack(spacing: 0.0) {
                    Picker("", selection: $viewModel.selectedContent) {
                        Text("Friends").tag(FriendSelectionContent.Friends)
                        Text("Requests").tag(FriendSelectionContent.Requests)
                        Text("Invitations").tag(FriendSelectionContent.Invitations)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    SearchBarView(searchText: $viewModel.searchQuery)
                }
                
                
                HeadingToolBarView(contentTitle: viewModel.selectedContent.contentTitle,
                                   isEditVisible: viewModel.isEditButtonVisible(),
                                   isEditing: isEditing,
                                   onEditClick: { isEditing.toggle() },
                                   onAddIconClick: { viewModel.isAddFriendSheetVisible.toggle() })
                .sheet(isPresented: $viewModel.isAddFriendSheetVisible) {
                    AddFriendView(friendsViewModel: viewModel)
                }
                
                //MARK: - Friends List
                ScrollView {
                    VStack(spacing: 15.0) {
                        if viewModel.selectedContent == .Friends {
                            ForEach(viewModel.getFilteredFriends(), id: \.self) { friend in
                                if isEditing {
                                    HStack {
                                        Button(action: {
                                            Task {
                                                await viewModel.removeFriend(friend: friend)
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 25)
                                                .foregroundStyle(Color.red)
                                        }
                                        .padding(.horizontal, 8)
                                        
                                        FriendCheckInRow(friendName: friend, isCheckInVisible: false)
                                    }
                                } else {
                                    NavigationLink(destination: FriendCheckInView(friendName: friend, friendsViewModel: viewModel)) {
                                        FriendCheckInRow(friendName: friend)
                                    }
                                }
                            }
                            
                        } else if viewModel.selectedContent == .Requests {
                            ForEach(viewModel.getFilteredRequests(), id: \.self) { request in
                                FriendRequestRow(name: request,
                                                 onAcceptClick: {
                                                     Task {
                                                        await viewModel.acceptFriendRequest(username: request)
                                                     }
                                                   },
                                                 onRejectClick: {
                                                     Task {
                                                        await viewModel.rejectFriendRequest(username: request)
                                                     }
                                                   }
                                                )
                            }
                            
                        } else {
                            ForEach(viewModel.getFilteredInvitations(), id: \.self) { invite in
                                FriendInviteRow(name: invite,
                                                onDismissClick: {
                                                    Task {
                                                        await viewModel.revokeFriendInvite(username: invite)
                                                    }
                                                })
                            }
                        }
                        
                    }
                }
//                .navigationDestination(for: String.self) { friend in
//                    FriendCheckInView(friendName: friend, friendsViewModel: viewModel)
//                }
                
            }
        }
    }
}

#Preview {
    FriendsView()
}
