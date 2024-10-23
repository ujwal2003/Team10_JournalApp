//
//  FriendsViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/22/24.
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
    
    @Published var selectedFriendMap: CityMap = CityMap(map: .LoadingMap, buildings: [], reports: [])
    @Published var selectedFriendCityBlock: String = "Loading..."
    @Published var selectedFriendWeather: JournalWeather = .NoData
    @Published var selectedFriendBuildingIndex: Int = 0
    @Published var selectedBuilding: Building = .BlueConstruction
    @Published var isSelectedFriendGrowthReportShowing: Bool = false
    
    @Published var isAddFriendSheetVisible: Bool = false
    @Published var cityInviteFailed: Bool = false
    @Published var isMapLoading: Bool = true
    
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
    
    func getWeatherStatus() -> (name: String, icon: String, iconWidth: CGFloat, iconColor: Color) {
        switch selectedFriendWeather {
            case .NoData:
                return (name: "No Data",
                        icon: "exclamationmark.arrow.trianglehead.2.clockwise.rotate.90",
                        iconWidth: 32,
                        iconColor: Color.gray)
                
            case .Sunny:
                return (name: "Sunny",
                        icon: "sun.max.fill",
                        iconWidth: 30,
                        iconColor: Color.yellow)
                
            case .Cloudy:
                return (name: "Cloudy",
                        icon: "cloud.sun.fill",
                        iconWidth: 35,
                        iconColor: Color.orange)
                
            case .Drizzle:
                return (name: "Drizzle",
                        icon: "sun.rain.fill",
                        iconWidth: 35,
                        iconColor: Color.cyan)
                
            case .Rain:
                return (name: "Rain",
                        icon: "cloud.rain.fill",
                        iconWidth: 28,
                        iconColor: Color.blue)
                
            case .Stormy:
                return (name: "Stormy",
                        icon: "hurricane",
                        iconWidth: 25,
                        iconColor: Color.indigo)
                
                
            default:
                return (name: "Error",
                        icon: "person.crop.circle.badge.exclamationmark",
                        iconWidth: 30,
                        iconColor: Color.red)
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
    
    //FIXME: - actually load from db
    func getFriendCurrWeekMap(friend: String) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            DispatchQueue.main.async {
                self.isMapLoading =  false
                
                let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
                
                let viewReport = { (idx: Int, building: Building) -> Void in
                    self.selectedFriendBuildingIndex = idx
                    self.selectedBuilding = building
                    self.isSelectedFriendGrowthReportShowing.toggle()
                }
                
                self.selectedFriendCityBlock = "Oct 20, 2024-Oct 26, 2024"
                self.selectedFriendMap = .init(map: .Map1,
                                               buildings: [
                                                .init(style: .BlueTower, onClick: { viewReport(0, .BlueTower) }),
                                                .init(style: .PurpleRuin, onClick: { viewReport(1, .PurpleRuin) }),
                                                .init(style: .GreenTower, onClick: { viewReport(2, .GreenTower) }),
                                                .init(style: .LightBrownTower, onClick: { viewReport(3, .LightBrownTower) }),
                                                .init(style: .RedTower, onClick: { viewReport(4, .RedTower) }),
                                                .init(style: .LightGreenTower, onClick: { viewReport(5, .LightGreenTower) }),
                                                .init(style: .YellowConstruction, onClick: { viewReport(6, .YellowConstruction) })
                                               ],
                                               reports: Array(repeating: .init(gratitudeSentiment: .Positive,
                                                                               gratitudeEntry: dummyText,
                                                                               learningSentiment: .Neutral,
                                                                               learningEntry: dummyText,
                                                                               thoughtSentiment: .Negative,
                                                                               thoughtEntry: dummyText),
                                                              count: 7))
            }
        }
    }
    
    //FIXME: - use actual weather calculation
    func calculateFriendWeather() async {
        DispatchQueue.main.async {
            self.selectedFriendWeather = .Sunny
        }
    }
}
