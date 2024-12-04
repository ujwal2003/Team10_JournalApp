//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/17/24.
//

import SwiftUI

struct HomeView: View {
    @State var usePreviewMocks: Bool = false
    
    @ObservedObject var appController: AppViewController
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        AppLayoutContainer(height: 10.0) {
            VStack(spacing: 0.0) {
                Text("CatchUp")
                    .font(.system(size: 30.0))
                    .fontWeight(.heavy)
                    .padding()
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Group {
                    if let userProfile = appController.loadedUserProfile {
                        Text("Welcome, \(userProfile.displayName)")
                    } else {
                        Text("Loading...")
                    }
                }
                .font(.system(size: 20.0))
                .fontWeight(.light)
                .padding([.leading, .trailing, .bottom])
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
        } containerContent: {
            VStack {
                CityStatsView(
                    percentage: viewModel.cityHealthPercentage,
                    weather: viewModel.currSentimentWeather
                )
                
                ActionButtonView(
                    isDisabled: false,
                    onClick: { viewModel.isRecommendedActionsShowing.toggle() }
                )
                .sheet(isPresented: $viewModel.isRecommendedActionsShowing) {
                    ReccomendedActionsView(overallSentiment: .Negative, actions: viewModel.recommendedActions)
                }
                
                UserJournalCityBlockView(
                    map: viewModel.currMap,
                    buildings: viewModel.currCityBlockBuildings
                )
                .sheet(isPresented: $viewModel.isGrowthReportShowing) {
                    if usePreviewMocks {
                        MockDataManager.mock.loadMockJournalBuildingView(homeViewModel: viewModel)
                    } else {
                        JournalEntryBuildingsView(
                            building: viewModel.currCityBlockBuildings[viewModel.selectedBuildingIndex].style,
                            date: viewModel.selectedBuildingDate,
                            journalID: viewModel.selectedJournalID
                        )
                    }
                }
                
                let loadedUserProfile = appController.loadedUserProfile
                
                BottomNavigationView(
                    isDisabled: viewModel.areNavigationButtonsDisabled,
                    onLeftArrowClick: {
                        if !self.usePreviewMocks {
                            if let profile = loadedUserProfile {
                                viewModel.navigateToPastWeek(userId: profile.userId)
                            }
                        }
                    },
                    onRightArrowClick: {
                        if !self.usePreviewMocks {
                            if let profile = loadedUserProfile {
                                viewModel.navigateToFutureWeek(userId: profile.userId)
                            }
                        }
                    },
                    currWeek: viewModel.currWeek,
                    numFriends: viewModel.numFriends
                )
                
            }
        }
        .task {
            if self.usePreviewMocks {
                MockDataManager.mock.loadMockUserProfile(appController: appController)
                MockDataManager.mock.loadMockUserJournalsMap(homeViewModel: viewModel)
                
            } else {
                viewModel.areNavigationButtonsDisabled = true
                
                if appController.loadedUserProfile == nil {
                    let authUserData = appController.certifyAuthStatus()
                    
                    if let userData = authUserData {
                        let userProfile = try? await UserManager.shared.getUser(userId: userData.uid)
                        appController.loadedUserProfile = userProfile
                    }
                }
                
                viewModel.cityHealthPercentage = 1.0
                
                viewModel.currWeek = CommonUtilities.util.getWeekRange(offset: viewModel.weekOffset)
                
                if let profile = appController.loadedUserProfile {
                    let todayOverallSentiment = await appController.getComputedSentimentForToday(userId: profile.userId)
                    
                    viewModel.currSentimentWeather = todayOverallSentiment.mappedWeather
                    viewModel.recommendedActions = []
                    
                    await viewModel.loadOrCreateCurrentWeekMap(userId: profile.userId)
                    
                    let userNumFriends = try? await FriendsManager.shared.getNumberOfFriends(userId: profile.userId)
                    viewModel.numFriends = userNumFriends ?? 0
                }
                
                viewModel.areNavigationButtonsDisabled = false
            }
        }

    }
}

#Preview {
    AppTabMockContainerView(previewTab: .Home) {
        HomeView(usePreviewMocks: true, appController: AppViewController())
    }
}
