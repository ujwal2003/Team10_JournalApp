//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/17/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        AppLayoutContainer(height: 10.0) {
            Text("CatchUp")
                .font(.system(size: 30.0))
                .fontWeight(.heavy)
                .padding()
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
                    ReccomendedActionsView(actions: viewModel.recommendedActions)
                }
                
                UserJournalCityBlockView(
                    map: viewModel.currMap,
                    buildings: viewModel.currCityBlockBuildings
                ) // add sheet for city growth here
                
                BottomNavigationView(
                    isDisabled: false,
                    onLeftArrowClick: {},
                    onRightArrowClick: {},
                    currWeek: viewModel.currWeek,
                    numFriends: 5
                )
                
            }
        }
        .onAppear {
            //FIXME: use stuff from DB here
            viewModel.currWeek = viewModel.getWeekRange(offset: 0)
            
            viewModel.cityHealthPercentage = 1.0
            viewModel.currSentimentWeather = .Sunny
            
            viewModel.currMap = .Map1
            viewModel.currCityBlockBuildings = [
                .init(style: .LightBlueTower, onClick: { viewModel.selectedBuildingIndex = 0 }),
                .init(style: .RedRuin, onClick: { viewModel.selectedBuildingIndex = 1 }),
                .init(style: .YellowConstruction, onClick: { viewModel.selectedBuildingIndex = 2 }),
                .init(style: .Scaffolding, onClick: { viewModel.selectedBuildingIndex = 3 }),
                .init(style: .PurpleConstruction, onClick: { viewModel.selectedBuildingIndex = 4 }),
                .init(style: .BrownTower, onClick: { viewModel.selectedBuildingIndex = 5 }),
                .init(style: .LightGreenTower, onClick: { viewModel.selectedBuildingIndex = 6 })
            ]
            
            viewModel.recommendedActions = [
                .init(searchQuery: "parks",
                      title: "Park",
                      description: "Going to the park is a great way to improve your physical and mental health."),
                
                    .init(searchQuery: "coffee shops",
                          title: "Chill & Chat",
                          description: "Reach out to a friend or loved one for a chat at a coffee shop")
            ]
            
        }

    }
}
