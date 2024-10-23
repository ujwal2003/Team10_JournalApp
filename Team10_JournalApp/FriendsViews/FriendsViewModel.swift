//
//  FriendsViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/22/24.
//

import Foundation

enum FriendSelectionContent {
    case Friends
    case Requests
    case Invitations
    
    var contentTitle: String {
        switch self {
            case .Friends: return "Your Friends"
            case .Requests: return "Friend Requests"
            case .Invitations: return "City Invitations"
        }
    }
}

class FriendsViewModel: ObservableObject {
    @Published var selectedContent: FriendSelectionContent
    @Published var searchQuery: String
    
    @Published var friends: [String] = []
    @Published var friendRequests: [String] = []
    @Published var friendInvites: [String] = []
    
    @Published var isAddFriendSheetVisible: Bool = false
    @Published var cityInviteFailed: Bool = false
    
    init(selectedContent: FriendSelectionContent = .Friends, searchQuery: String = "") {
        self.selectedContent = selectedContent
        self.searchQuery = searchQuery
        
        Task {
            await downloadFriendsData()
        }
    }
    
    func isEditButtonVisible() -> Bool {
        return self.selectedContent == .Friends
    }
    
    func getFilteredFriends() -> [String] {
        guard !searchQuery.isEmpty else { return friends }
        
        return friends.filter { friend in
            return friend.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    func getFilteredRequests() -> [String] {
        guard !searchQuery.isEmpty else { return friendRequests }
        
        return friendRequests.filter { request in
            return request.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    func getFilteredInvitations() -> [String] {
        guard !searchQuery.isEmpty else { return friendInvites }
        
        return friendInvites.filter { invite in
            return invite.lowercased().contains(searchQuery.lowercased())
        }
    }
    
    //FIXME: - use data from actual db
    func downloadFriendsData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.friends = ["Friend 1", "Friend 2", "Friend 3", "Friend 4", "Friend 5"]
            self.friendRequests = ["New Friend 1", "New Friend 2"]
            self.friendInvites = ["Person 1", "Person 2"]
        }
    }
    
    //FIXME: - actually delete from db
    func removeFriend(friend: String) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.friends.removeAll{ $0 == friend }
        }
    }
    
    //FIXME: - acutally send request to server
    func sendCityInvite(username: String) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let willFail = Bool.random()
            
            if !willFail {
                self.friendInvites.append(username)
            } else {
                self.cityInviteFailed = true
            }
            
        }
    }
    
    //FIXME: - acctually update friends & requests list in db
    func acceptFriendRequest(username: String) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.friends.append(username)
            self.friendRequests.removeAll{ $0 == username }
        }
    }
    
    //FIXME: - actually update requests list in db
    func rejectFriendRequest(username: String) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.friendRequests.removeAll{ $0 == username }
        }
    }
    
    //FIXME: - actually update invites list in db
    func revokeFriendInvite(username: String) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.friendInvites.removeAll{ $0 == username }
        }
    }
}
