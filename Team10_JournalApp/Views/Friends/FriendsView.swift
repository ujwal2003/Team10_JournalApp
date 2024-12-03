//
//  FriendsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/22/24.
//

import SwiftUI

struct FriendsView: View {
    @State var usePreviewMocks: Bool = false
    
    @ObservedObject var appController: AppViewController
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
                    )
                    .sheet(isPresented: $viewModel.isAddFriendSheetVisible) {
                        AddFriendView()
                    }
                    
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
                
                if viewModel.isDataLoading {
                    ProgressBufferView {
                        Text("Loading...")
                    }
                }
                
            }
            .onFirstAppear {
                // load friends on first appearance
                if !usePreviewMocks {
                    FriendsManager.shared.removeAllUserFriendsListener()
                    
                    if let profile = appController.loadedUserProfile {
                        FriendsManager.shared.addListenerForUserFriendsWithStatus(
                            userId: profile.userId,
                            status: FriendStatus.friend,
                            triggeredOn: [.added, .removed]
                        ) { userFriend, changeType in
                            
                            if changeType == .added {
                                viewModel.lazyLoadUserFriendData(userFriendStat: userFriend, status: .friend)
                            }
                            
                        }
                    }
                }
            }
            .onChange(of: viewModel.selectedContent) { oldValue, newValue in
                if !usePreviewMocks {
                    FriendsManager.shared.removeAllUserFriendsListener()
                    
                    if let profile = appController.loadedUserProfile {
                        FriendsManager.shared.addListenerForUserFriendsWithStatus(
                            userId: profile.userId,
                            status: newValue.status, triggeredOn: [.added, .removed, .modified]) { userFriendData, changeType in
                                
                                if changeType == .added {
                                    viewModel.lazyLoadUserFriendData(userFriendStat: userFriendData, status: newValue.status)
                                }
                                
                            }
                    }
                }
            }
            .onDisappear {
                if !usePreviewMocks {
                    FriendsManager.shared.removeAllUserFriendsListener()
                }
            }
            
        }
    }
}

#Preview {
    AppTabMockContainerView(previewTab: .Friends) {
        FriendsView(appController: AppViewController())
    }
}
