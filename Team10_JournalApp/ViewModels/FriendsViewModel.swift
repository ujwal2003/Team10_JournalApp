//
//  FriendsViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/28/24.
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

struct DBUserInfo {
    let userID: String
    let email: String
    let displayName: String
}

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var selectedContent: FriendSelectionContent = .Friends
    @Published var searchQuery: String = ""
    
    @Published var friends: [DBUserInfo] = []
    @Published var friendRequests: [DBUserInfo] = []
    @Published var friendInvites: [DBUserInfo] = []
    
    @Published var selectedFriendMap: Map = .LoadingMap
    @Published var selectedFriendBuildings: [BuildingConfig] = []
    @Published var selectedFriendJournals: [GrowthReport] = []
    
    @Published var selectedFriendJournalWeek: String = "Loading..."
    @Published var selectedFriendWeather: JournalWeather = .NoData
    
    @Published var selectedFriendBuildingIndex: Int = 0
    @Published var selectedBuilding: Building = .BlueConstruction
    
    @Published var isSelectedFriendGrowthReportShowing: Bool = false
    @Published var isAddFriendSheetVisible: Bool = false
    @Published var cityInviteFailedAlert: Bool = false
    @Published var isMapLoading: Bool = true
}
