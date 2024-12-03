//
//  FriendsViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/28/24.
//

import Foundation
import SwiftUI

enum FriendSelectionContent {
    case Friends
    case Requests
    case Invitations
    
    var contentTitle: String {
        switch self {
            case .Friends: return "Your Friends"
            case .Requests: return "Friend Requests"
            case .Invitations: return "Your Invites"
        }
    }
    
    var status: FriendStatus {
        switch self {
            case .Friends:
                return .friend
            case .Requests:
                return .incomingRequest
            case .Invitations:
                return .invited
        }
    }
}

struct DBUserInfo: Hashable {
    let userID: String
    let email: String
    let displayName: String
}

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var selectedContent: FriendSelectionContent = .Friends
    @Published var searchQuery: String = ""
    
    @Published var friends: Set<DBUserInfo> = []
    @Published var friendRequests: Set<DBUserInfo> = []
    @Published var friendInvites: Set<DBUserInfo> = []
    
    @Published var selectedFriendMap: Map = .LoadingMap
    @Published var selectedFriendBuildings: [BuildingConfig] = []
    @Published var selectedFriendJournals: [GrowthReport] = []
    
    @Published var selectedFriendJournalWeek: String = "Loading..."
    @Published var selectedFriendWeather: JournalWeather = .NoData
    
    @Published var isAddFriendSheetVisible: Bool = false
    @Published var cityInviteFailedAlert: Bool = false
    @Published var isMapLoading: Bool = true
    
    @Published var isDataLoading: Bool = false
    
    func isSelectedContentListEmpty() -> Bool {
        switch self.selectedContent {
            case .Friends: return self.friends.isEmpty
            case .Requests: return self.friendRequests.isEmpty
            case .Invitations: return self.friendInvites.isEmpty
        }
    }
    
    func getFilteredFriends() -> Set<DBUserInfo> {
        guard !searchQuery.isEmpty else { return friends }
        
        return friends.filter { friend in
            return friend.displayName.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    func getFilteredRequests() -> Set<DBUserInfo> {
        guard !searchQuery.isEmpty else { return friendRequests }
        
        return friendRequests.filter { request in
            return request.displayName.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    func getFilteredInvitations() -> Set<DBUserInfo> {
        guard !searchQuery.isEmpty else { return friendInvites }
        
        return friendInvites.filter { invite in
            return invite.displayName.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    //FIXME: - actually delete from db
    func removeFriend(friend: DBUserInfo) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        print("\(friend.displayName) deleted from database")
    }
    
    func deleteFriend(at offsets: IndexSet) {
        
    }
    
    func getContentList() -> AnyView {
        switch self.selectedContent {
            case .Friends:
                return AnyView(
                    ForEach(Array(self.getFilteredFriends()), id: \.userID) { friendProfileInfo in
                        FriendListRowView(
                            itemName: friendProfileInfo.displayName,
                            itemContent: .checkIn
                        )
                        .background(
                            NavigationLink(
                                "",
                                destination: FriendCheckInView(friendDBInfo: friendProfileInfo)
                            ).opacity(0)
                        )
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: self.deleteFriend(at:))
                )
            
            case .Requests:
                return AnyView(
                    ForEach(Array(self.getFilteredRequests()), id: \.userID) { requestProfileInfo in
                        FriendListRowView(
                            itemName: requestProfileInfo.displayName,
                            itemContent: .requestButtons(
                                onAccept: {
                                    
                                },
                                onReject: {
                                    
                                }
                            )
                        )
                    }
                )
            
            case .Invitations:
                return AnyView(
                    ForEach(Array(self.getFilteredInvitations()), id: \.userID) { inviteProfileInfo in
                        FriendListRowView(
                            itemName: inviteProfileInfo.displayName,
                            itemContent: .inviteRescindButton(
                                onRevoke: {
                                    
                                }
                            )
                        )
                    }
                )
        }
    }
    
    // MARK: - DB Stuff
    func lazyLoadUserFriendData(userFriendStat: UserFriendStatus, status: FriendStatus) {
        Task {
            self.isDataLoading = true
            
            let fetchUserFromDB = try? await UserManager.shared.getUser(userId: userFriendStat.friendUserId)
            
            if let fetchedUser = fetchUserFromDB {
                let friendDBUser = DBUserInfo(userID: fetchedUser.userId, email: fetchedUser.email, displayName: fetchedUser.displayName)
                
                switch status {
                    case .friend:
                    self.friends.insert(friendDBUser)
                    case .incomingRequest:
                        self.friendRequests.insert(friendDBUser)
                    case .invited:
                        self.friendInvites.insert(friendDBUser)
                    case .unknown:
                        break
                }
            }
            
            self.isDataLoading = false
        }
    }
    
}
