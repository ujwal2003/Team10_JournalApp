//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    //FIXME: - pass in weather status from journal entry sentiment calculation
    //FIXME: - pass in reccomended actions from journal entry sentiment calculation
    //FIXME: - pass in num friends from initial user data fetch
    @StateObject private var viewModel = HomeViewModel(weatherStatus: .NoData,
                                                       recommendedActions: [
                                                        .init(searchQuery: "parks",
                                                              title: "Park",
                                                              description: "Going to the park is a great way to improve your physical and mental health."),
                                                        
                                                            .init(searchQuery: "coffee shops",
                                                                  title: "Chill & Chat",
                                                                  description: "Reach out to a friend or loved one for a chat at a coffee shop")
                                                       ],
                                                       numFriends: 5)
    
    var body: some View {
        ZStack {
            DefaultRectContainer(title: .init(text: "CatchUp", fontSize: 30.0),
                                 subtitle: .init(text: "", fontSize: 20.0)) {
                

                CityHealthWeatherView(cityHealthPercentage: .constant(viewModel.calcCityHealthPercentage()),
                                      cityHealthBar: viewModel.getCityHealthColors(),
                                      todaysWeather: viewModel.getWeatherStatus())
                
                
                ActionButtonView(isDisabled: viewModel.isNavigateLoading,
                                 onClick: { viewModel.isRecommendedActionsShowing.toggle() })
                    .sheet(isPresented: $viewModel.isRecommendedActionsShowing) {
                        ReccomendedActionsView(actions: viewModel.recommendedActions)
                    }
                
                
                
                let currCityMap = viewModel.currCityJournal
                
                CityJournalMapView(map: currCityMap.map, buildings: currCityMap.buildings)
                    .sheet(isPresented: $viewModel.isGrowthReportShowing) {
                        let reportIdx = viewModel.selectedBuildingIndex
                        
                        CityGrowthView(headlineTitle: "\(viewModel.days[reportIdx])'s City Growth",
                                       growthReport: currCityMap.reports[reportIdx])
                    }
                
                
                BottomNavigationView(isDisabled: viewModel.isNavigateLoading,
                                     onLeftArrowClick: {
                                         Task {
                                             await viewModel.getPastCity()
                                         }
                                     },
                                     onRightArrowClick: {
                                         Task {
                                            await viewModel.getFutureCity()
                                         }
                                     },
                                     currWeek: viewModel.currCityBlock,
                                     numFriends: viewModel.numFriends)
                
                
                Spacer()
            }
            
            if viewModel.isNavigateLoading {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                                
                ProgressView("Loading Data...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            
        }
        
    }
}
