//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(cityHealthPercentage: 1.0,
                                                       weatherStatus: .Cloudy,
                                                       numFriends: 5,
                                                       dummyWeek: 0)
    
    var body: some View {
        ZStack {
            DefaultRectContainer(title: .init(text: "CatchUp", fontSize: 30.0),
                                 subtitle: .init(text: "", fontSize: 20.0)) {
                
                CityHealthWeatherView(cityHealthPercentage: $viewModel.cityHealthPercentage,
                                      cityHealthBar: viewModel.getCityHealthColors(),
                                      todaysWeather: viewModel.getWeatherStatus())
                
                
                ActionButtonView(isDisabled: viewModel.isNavigateLoading,
                                 onClick: { print("TODO: Actions") })
                
                
                let currCityMap = viewModel.getCityMap(week: viewModel.dummyWeek)
                
                CityJournalMapView(map: currCityMap.map, buildings: currCityMap.buildings)
                    .sheet(isPresented: $viewModel.isGrowthReportShowing) {
                        let dayIndex = viewModel.selectedGrowthReportIndex
                        
                        CityGrowthView(headlineTitle: "\(viewModel.days[dayIndex])'s City Growth",
                                       growthReport: currCityMap.reports[dayIndex])
                    }
                
                BottomNavigationView(isDisabled: viewModel.isNavigateLoading,
                                     onLeftArrowClick: { },
                                     onRightArrowClick: { },
                                     currWeek: viewModel.getCurrCityBlock(),
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

//#Preview {
//    HomeView()
//}
