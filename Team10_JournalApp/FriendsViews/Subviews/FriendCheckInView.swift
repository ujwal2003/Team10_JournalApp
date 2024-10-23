//
//  FriendCheckInView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/23/24.
//

import SwiftUI

struct FriendCheckInView: View {
    @State var friendName: String
    @ObservedObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 15.0) {
                Text("\(friendName)’s City")
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Text("City Block: \(friendsViewModel.selectedFriendCityBlock)")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            .padding()
            
            let friendCityMap = friendsViewModel.selectedFriendMap
            
            CityJournalMapView(map: friendCityMap.map, buildings: friendCityMap.buildings)
                .sheet(isPresented: $friendsViewModel.isSelectedFriendGrowthReportShowing) {
                    let reportIdx = friendsViewModel.selectedFriendBuildingIndex
                    
                    CityGrowthView(headlineTitle: "",
                                   buildingType: friendsViewModel.selectedBuilding.category,
                                   growthReport: friendCityMap.reports[reportIdx])
                }
                .padding(25)
            
            Spacer().frame(height: 160)
        }
        .task {
            await friendsViewModel.getFriendCurrWeekMap(friend: friendName)
        }
        
    }
}
