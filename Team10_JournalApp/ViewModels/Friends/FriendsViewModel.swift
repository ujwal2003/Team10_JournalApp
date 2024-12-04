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
    @Published var currUserProfile: UserProfile? = nil
    
    @Published var selectedContent: FriendSelectionContent = .Friends
    @Published var searchQuery: String = ""
    
    @Published var friends: Set<DBUserInfo> = []
    @Published var friendRequests: Set<DBUserInfo> = []
    @Published var friendInvites: Set<DBUserInfo> = []
    
    @Published var isAddFriendSheetVisible: Bool = false
    @Published var isMapLoading: Bool = true
    
    @Published var cityInviteFailedAlert: Bool = false
    @Published var isCityInviteRevokeFailedAlertShowing: Bool = false
    @Published var isAcceptFriendRequestFailedAlertShowing: Bool = false
    @Published var isRejectFriendRequestFailedAlertShowing: Bool = false
    @Published var isRemoveFriendFailedAlertShowing: Bool = false
    
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
    
    func removeDBUserByID(uid: String, status: FriendStatus) {
        if status == .friend {
            
        } else if status == .invited {
            if let objToRemove = self.friendInvites.first(where: { $0.userID == uid }) {
                self.friendInvites.remove(objToRemove)
            }
            
        } else if status == .incomingRequest {
            if let objToRemove = self.friendRequests.first(where: { $0.userID == uid }) {
                self.friendRequests.remove(objToRemove)
            }
        }
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
                    .onDelete(perform: { indices in
                        for index in indices {
                            let itemToDelete = Array(self.getFilteredFriends())[index]
                            
                            print("attempting to remove: \(itemToDelete)")
                            self.removeFriend(friendDBObj: itemToDelete)
                        }
                    })
                )
            
            case .Requests:
                return AnyView(
                    ForEach(Array(self.getFilteredRequests()), id: \.userID) { requestProfileInfo in
                        FriendListRowView(
                            itemName: requestProfileInfo.displayName,
                            itemContent: .requestButtons(
                                onAccept: {
                                    self.acceptFriendRequest(incomingReqUserId: requestProfileInfo.userID)
                                },
                                onReject: {
                                    self.rejectFriendRequest(incomingRequestId: requestProfileInfo.userID)
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
                                    self.revokeFriendInvite(invitedUserId: inviteProfileInfo.userID)
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
    
    func sendFriendInvite(userId: String, potentialFriendEmail: String, onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        guard !userId.isEmpty, !potentialFriendEmail.isEmpty else {
            return
        }
        
        Task {
            do {
                let potentialFriend = try await UserManager.shared.getUserByEmailSearch(email: potentialFriendEmail)
                
                try await FriendsManager.shared.addUserNewFriendWithStatus(userId: userId, friendId: potentialFriend.userId, status: .invited)
                try await FriendsManager.shared.addUserNewFriendWithStatus(userId: potentialFriend.userId, friendId: userId, status: .incomingRequest)
                
                print("Succesfully invited \(potentialFriendEmail) to be a friend")
                
                onSuccess()
                
            } catch {
                print("Failed to invite \(potentialFriendEmail)")
                onFailure()
            }
        }
    }
    
    func revokeFriendInvite(invitedUserId: String) {
        Task {
            self.isDataLoading = true
            
            do {
                if let profile = self.currUserProfile {
                    try await FriendsManager.shared.removeUserFriendWithStatus(userId: profile.userId, friendId: invitedUserId, status: .invited)
                    try await FriendsManager.shared.removeUserFriendWithStatus(userId: invitedUserId, friendId: profile.userId, status: .incomingRequest)
                }
                
                self.isDataLoading = false
                
            } catch {
                self.isDataLoading = false
                self.isCityInviteRevokeFailedAlertShowing.toggle()
            }
        }
    }
    
    func acceptFriendRequest(incomingReqUserId: String) {
        Task {
            self.isDataLoading = true
            
            do {
                if let profile = self.currUserProfile {
                    try await FriendsManager.shared.updateUserFriendStatus(userId: profile.userId, friendId: incomingReqUserId, status: .friend)
                    try await FriendsManager.shared.updateUserFriendStatus(userId: incomingReqUserId, friendId: profile.userId, status: .friend)
                }
                
                self.isDataLoading = false
                
            } catch {
                self.isDataLoading = false
                self.isAcceptFriendRequestFailedAlertShowing.toggle()
            }
        }
    }
    
    func rejectFriendRequest(incomingRequestId: String) {
        Task {
            self.isDataLoading = true
            
            do {
                if let profile = self.currUserProfile {
                    try await FriendsManager.shared.removeUserFriendWithStatus(userId: profile.userId, friendId: incomingRequestId, status: .incomingRequest)
                    try await FriendsManager.shared.removeUserFriendWithStatus(userId: incomingRequestId, friendId: profile.userId, status: .invited)
                }
                
                self.isDataLoading = false
                
            } catch {
                self.isDataLoading = false
                self.isRejectFriendRequestFailedAlertShowing.toggle()
            }
        }
    }
    
    func removeFriend(friendDBObj: DBUserInfo) {
        Task {
            self.isDataLoading = true
            
            do {
                if let profile = currUserProfile {
                    try await FriendsManager.shared.removeUserFriendWithStatus(userId: profile.userId, friendId: friendDBObj.userID, status: .friend)
                    try await FriendsManager.shared.removeUserFriendWithStatus(userId: friendDBObj.userID, friendId: profile.userId, status: .friend)
                }
                
                self.friends.remove(friendDBObj)
                self.isDataLoading = false
                
            } catch {
                self.friends.insert(friendDBObj)
                self.isDataLoading = false
                self.isRemoveFriendFailedAlertShowing.toggle()
            }
        }
    }
    
}
