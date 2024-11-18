//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/17/24.
//

import SwiftUI

struct HomeView: View {
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
                CityHealthWeatherView(
                    cityHealthPercentage: .constant(1.0),
                    cityHealthBar: (borderColor: Color(red: 0, green: 0.66, blue: 0.39).opacity(0.4),
                                    barColor: Color(red: 0.79, green: 1, blue: 0.87)),
                    todaysWeather: JournalWeather.Sunny.weatherStatusStyle
                )
                
                ActionButtonView(
                    isDisabled: false,
                    onClick: {}
                ) // add sheet for reccomended actions here
                
                UserJournalCityBlockView(
                    map: .Map1,
                    buildings: [
                        .init(style: .LightBlueTower, onClick: {}),
                        .init(style: .RedRuin, onClick: {}),
                        .init(style: .PurpleConstruction, onClick: {}),
                        .init(style: .Scaffolding, onClick: {}),
                        .init(style: .PurpleConstruction, onClick: {}),
                        .init(style: .BrownTower, onClick: {}),
                        .init(style: .LightGreenTower, onClick: {})
                    ]
                ) // add sheet for city growth here
                
                BottomNavigationView(
                    isDisabled: false,
                    onLeftArrowClick: {},
                    onRightArrowClick: {},
                    currWeek: "XX/XX/XX - XX/XX/XX",
                    numFriends: 5
                )
                
            }
        }

    }
}
