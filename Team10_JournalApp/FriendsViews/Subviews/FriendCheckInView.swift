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
                .padding(isIphone16ProMaxPortrait ? 8 : 25)
            
            VStack {
                Text("\(friendName)’s City weather is: ")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                let friendWeather = friendsViewModel.getWeatherStatus()
                
                HStack {
                    Text(friendWeather.name)
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                    
                    Image(systemName: friendWeather.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: friendWeather.iconWidth)
                        .foregroundStyle(friendWeather.iconColor)
                }
            }
            
            Spacer().frame(height: isIphone16ProMaxPortrait ? 140 : 90)
        }
        .task {
            await friendsViewModel.getFriendCurrWeekMap(friend: friendName)
            friendsViewModel.calculateFriendWeather()
        }
        
    }
}
