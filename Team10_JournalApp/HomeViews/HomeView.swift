//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    //FIXME: - pass in weather status from journal entry sentiment calculation
    //FIXME: - pass in num friends from initial user data fetch
    @StateObject private var viewModel = HomeViewModel(weatherStatus: .NoData, numFriends: 5)
    
    var body: some View {
        ZStack {
            DefaultRectContainer(title: .init(text: "CatchUp", fontSize: 30.0),
                                 subtitle: .init(text: "", fontSize: 20.0)) {
                
                CityHealthWeatherView(cityHealthPercentage: .constant(viewModel.calcCityHealthPercentage()),
                                      cityHealthBar: viewModel.getCityHealthColors(),
                                      todaysWeather: viewModel.getWeatherStatus())
                
                
                ActionButtonView(isDisabled: viewModel.isNavigateLoading,
                                 onClick: { print("TODO: Actions") })
                
                
                let currCityMap = viewModel.currCityJournal
                
                CityJournalMapView(map: currCityMap.map, buildings: currCityMap.buildings)
                    .sheet(isPresented: $viewModel.isGrowthReportShowing) {
//                        CityGrowthView(headlineTitle: "\(viewModel.days[dayIndex])'s City Growth",
//                                       growthReport: currCityMap.reports[dayIndex])
                    }
                
                BottomNavigationView(isDisabled: viewModel.isNavigateLoading,
                                     onLeftArrowClick: { },
                                     onRightArrowClick: { },
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
