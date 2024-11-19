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
                )
                .sheet(isPresented: $viewModel.isGrowthReportShowing) {
                    let day = "\(dayToIndex[viewModel.selectedBuildingIndex] ?? "Day")"
                    let selectedBuilding = viewModel.currCityBlockBuildings[viewModel.selectedBuildingIndex].style
                    
                    var growthHeadline: String {
                        if selectedBuilding.category == .Ruin {
                            return "Ruins of \(day)"
                        }
                        
                        return "\(day) City Growth"
                    }
                    
                    let currWeekJournal = viewModel.currWeekJournal
                    if !currWeekJournal.isEmpty {
                        CityJournalBuildingView(
                            headlineTitle: growthHeadline,
                            building: selectedBuilding,
                            growthReport: viewModel.currWeekJournal[viewModel.selectedBuildingIndex]
                        )
                        
                    } else {
                        CityJournalBuildingView(
                            headlineTitle: growthHeadline,
                            building: selectedBuilding,
                            growthReport: .init(
                                gratitudeSentiment: .Neutral,
                                gratitudeEntry: "ERROR",
                                learningSentiment: .Neutral,
                                learningEntry: "ERROR",
                                thoughtSentiment: .Neutral,
                                thoughtEntry: "ERROR"),
                            selectedMenuView: .Journal
                        )
                    }
                    
                }
                
                BottomNavigationView(
                    isDisabled: false,
                    onLeftArrowClick: { print("TODO: Navigate Previous") },
                    onRightArrowClick: { print("TODO: Navigate Next") },
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
            
            let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
            viewModel.currWeekJournal = Array(repeating: .init(gratitudeSentiment: .Positive,
                                                               gratitudeEntry: dummyText,
                                                               learningSentiment: .Neutral,
                                                               learningEntry: dummyText,
                                                               thoughtSentiment: .Negative,
                                                               thoughtEntry: dummyText),
                                              count: 7)
            
            viewModel.currMap = .Map1
            viewModel.currCityBlockBuildings = [
                .init(style: .LightBlueTower, onClick: {
                    viewModel.selectedBuildingIndex = 0
                    viewModel.isGrowthReportShowing.toggle()
                }),
                .init(style: .RedRuin, onClick: {
                    viewModel.selectedBuildingIndex = 1
                    viewModel.isGrowthReportShowing.toggle()
                }),
                .init(style: .YellowConstruction, onClick: {
                    viewModel.selectedBuildingIndex = 2
                    viewModel.isGrowthReportShowing.toggle()
                }),
                .init(style: .Scaffolding, onClick: {
                    viewModel.selectedBuildingIndex = 3
                    viewModel.isGrowthReportShowing.toggle()
                }),
                .init(style: .PurpleConstruction, onClick: {
                    viewModel.selectedBuildingIndex = 4
                    viewModel.isGrowthReportShowing.toggle()
                }),
                .init(style: .BrownTower, onClick: {
                    viewModel.selectedBuildingIndex = 5
                    viewModel.isGrowthReportShowing.toggle()
                }),
                .init(style: .LightGreenTower, onClick: {
                    viewModel.selectedBuildingIndex = 6
                    viewModel.isGrowthReportShowing.toggle()
                })
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
