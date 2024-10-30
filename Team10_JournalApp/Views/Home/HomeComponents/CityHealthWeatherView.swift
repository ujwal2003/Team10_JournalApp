//
//  CityHealthWeatherView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/20/24.
//

import SwiftUI

struct CityHealthWeatherView: View {
    @Binding var cityHealthPercentage: CGFloat
    var cityHealthBar: (borderColor: Color, barColor: Color)
    var todaysWeather: (name: String, icon: String, iconWidth: CGFloat, iconColor: Color)
    
    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 0) {
            GridRow {
                Text("City Health")
                    .font(.system(size: 18.0))
                    .fontWeight(.medium)
                    .gridColumnAlignment(.leading)
                
                CapsuleProgressBar(percent: $cityHealthPercentage,
                                   height: 25.0,
                                   borderColor: cityHealthBar.borderColor,
                                   borderWidth: 1.0,
                                   barColor: cityHealthBar.barColor)
                .frame(width: 200)
                .padding()
                .gridColumnAlignment(.center)
            }
            
            GridRow {
                Text("Weather")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                HStack {
                    Text(todaysWeather.name)
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                    
                    Image(systemName: todaysWeather.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: todaysWeather.iconWidth)
                        .foregroundStyle(todaysWeather.iconColor)
                }
            }
            
        }
        .padding()
        .padding(.leading)
    }
}
