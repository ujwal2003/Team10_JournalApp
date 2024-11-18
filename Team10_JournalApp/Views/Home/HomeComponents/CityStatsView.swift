//
//  CityStatsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/18/24.
//

import SwiftUI

struct CityStatsView: View {
    var percentage: CGFloat
    var weather: JournalWeather
    
    var body: some View {
        if percentage >= 0.75 {
            CityHealthWeatherView(
                cityHealthPercentage: .constant(percentage),
                cityHealthBar: (borderColor: Color(red: 0, green: 0.66, blue: 0.39).opacity(0.4),
                                       barColor: Color(red: 0.79, green: 1, blue: 0.87)),
                todaysWeather: weather.weatherStatusStyle
            )
            
        } else if percentage >= 0.50 {
            CityHealthWeatherView(
                cityHealthPercentage: .constant(percentage),
                cityHealthBar: (borderColor: Color(red: 0.84, green: 0.86, blue: 0.01).opacity(0.53),
                                barColor: Color(red: 0.98, green: 1, blue: 0.79)),
                todaysWeather: weather.weatherStatusStyle
            )
            
        } else if percentage >= 0.25 {
            CityHealthWeatherView(
                cityHealthPercentage: .constant(percentage),
                cityHealthBar: (borderColor: Color(red: 0.66, green: 0.46, blue: 0).opacity(0.4),
                                barColor: Color(red: 1, green: 0.94, blue: 0.79)),
                todaysWeather: weather.weatherStatusStyle
            )
            
        } else {
            CityHealthWeatherView(
                cityHealthPercentage: .constant(percentage),
                cityHealthBar: (borderColor: Color(red: 0.66, green: 0.16, blue: 0).opacity(0.4),
                                barColor: Color(red: 1, green: 0.84, blue: 0.79)),
                todaysWeather: weather.weatherStatusStyle
            )
        }
        
    }
}
