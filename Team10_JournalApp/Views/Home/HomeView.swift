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
                    // TODO: show growth report
                }
                
                BottomNavigationView(
                    isDisabled: false,
                    onLeftArrowClick: { print("TODO: Navigate Previous") },
                    onRightArrowClick: { print("TODO: Navigate Next") },
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
                if appController.loadedUserProfile == nil {
                    let authUserData = appController.certifyAuthStatus()
                    
                    if let userData = authUserData {
                        let userProfile = try? await UserManager.shared.getUser(userId: userData.uid)
                        appController.loadedUserProfile = userProfile
                    }
                }
                
                viewModel.cityHealthPercentage = 1.0
                viewModel.currSentimentWeather = .NoData
                viewModel.recommendedActions = []
                viewModel.currWeek = CommonUtilities.util.getWeekRange(offset: viewModel.weekOffset)
                
                if let profile = appController.loadedUserProfile {
                    await viewModel.loadOrCreateCurrentWeekMap(userId: profile.userId)
                }
                
            }
        }

    }
}

#Preview {
    AppTabMockContainerView(previewTab: .Home) {
        HomeView(usePreviewMocks: true, appController: AppViewController())
    }
}
