//
//  FriendCheckInView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/23/24.
//

import SwiftUI

struct FriendCheckInView: View {
    @State var usePreviewMocks: Bool = false
    
    @StateObject var viewModel = FriendCheckInViewModel()
    @State var friendDBInfo: DBUserInfo
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        Group {
            // Conditional ScrollView for landscape mode
            if DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass).isLandscape(device: .iPhone) {
                ScrollView {
                    content
                }
            } else {
                content
            }
        }
        .task {
            if self.usePreviewMocks {
                MockDataManager.mock.loadMockFriendJournalsMap(checkInViewModel: viewModel)
            } else {
                let todayOverallFriendSentiment = await CommonUtilities.util.getComputedSentimentForToday(userId: friendDBInfo.userID)
                viewModel.friendSentimentWeather = todayOverallFriendSentiment.mappedWeather
                await viewModel.loadFriendCurrentWeekMap(friendUserId: friendDBInfo.userID)
            }
        }
    }
    
    // Main content of the FriendCheckInView
    private var content: some View {
        VStack {
            VStack(spacing: 15.0) {
                Text("\(friendDBInfo.displayName)'s City")
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
                    .foregroundStyle(.black)
                
                Text("City Block: \(CommonUtilities.util.getWeekRange(offset: 0))")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
            }
            .padding()
            
            UserJournalCityBlockView(
                map: viewModel.friendCityMap,
                buildings: viewModel.friendCityBlockBuildings
            )
            .sheet(isPresented: $viewModel.isGrowthReportShowing) {
                if !usePreviewMocks {
                    JournalEntryBuildingsView(
                        selectedMenuView: .Journal,
                        building: viewModel.friendCityBlockBuildings[viewModel.selectedBuildingIndex].style,
                        date: viewModel.selectedBuildingDate,
                        journalID: viewModel.selectedJournalID
                    )
                }
            }
            
            VStack {
                Text("\(friendDBInfo.displayName)’s City weather is: ")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                let friendWeather = viewModel.friendSentimentWeather.weatherStatusStyle
                
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
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    FriendCheckInView(
        usePreviewMocks: true,
        friendDBInfo: .init(userID: "iuyeiqwyiq8276388", email: "test", displayName: "Friend1")
    )
}
