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
                    onClick: {}
                ) // add sheet for reccomended actions here
                
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
            viewModel.currSentimentWeather = .Cloudy
            
            viewModel.currMap = .Map1
            viewModel.currCityBlockBuildings = [
                .init(style: .LightBlueTower, onClick: {}),
                .init(style: .RedRuin, onClick: {}),
                .init(style: .PurpleConstruction, onClick: {}),
                .init(style: .Scaffolding, onClick: {}),
                .init(style: .PurpleConstruction, onClick: {}),
                .init(style: .BrownTower, onClick: {}),
                .init(style: .LightGreenTower, onClick: {})
            ]
            
        }

    }
}
