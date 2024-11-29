//
//  JournalWeather.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/30/24.
//

import Foundation
import SwiftUI

let dayToIndex = [
    0 : "Sunday",
    1 : "Monday",
    2 : "Tuesday",
    3 : "Wednesday",
    4 : "Thursday",
    5 : "Friday",
    6 : "Saturday",
]

enum JournalWeather {
    case Sunny
    case Cloudy
    case Drizzle
    case Rain
    case Stormy
    case NoData
    case Error
    
    var weatherStatusStyle: (name: String, icon: String, iconWidth: CGFloat, iconColor: Color) {
        switch self {
            case .NoData:
                return (name: "No Data",
                        icon: "exclamationmark.arrow.trianglehead.2.clockwise.rotate.90",
                        iconWidth: 32,
                        iconColor: Color.gray)
                
            case .Sunny:
                return (name: "Sunny",
                        icon: "sun.max.fill",
                        iconWidth: 30,
                        iconColor: Color.yellow)
                
            case .Cloudy:
                return (name: "Cloudy",
                        icon: "cloud.sun.fill",
                        iconWidth: 35,
                        iconColor: Color.orange)
                
            case .Drizzle:
                return (name: "Drizzle",
                        icon: "sun.rain.fill",
                        iconWidth: 35,
                        iconColor: Color.cyan)
                
            case .Rain:
                return (name: "Rainy",
                        icon: "cloud.rain.fill",
                        iconWidth: 28,
                        iconColor: Color.blue)
                
            case .Stormy:
                return (name: "Stormy",
                        icon: "hurricane",
                        iconWidth: 25,
                        iconColor: Color.indigo)
                
            default:
                return (name: "Error",
                        icon: "person.crop.circle.badge.exclamationmark",
                        iconWidth: 30,
                        iconColor: Color.red)
        }
    }
}

struct GrowthReport {
    var gratitudeSentiment: Sentiment
    var gratitudeEntry: String
    
    var learningSentiment: Sentiment
    var learningEntry: String
    
    var thoughtSentiment: Sentiment
    var thoughtEntry: String
}

@available(*, deprecated, message: "Manually embed journal city configurations into component.")
struct CityMap {
    var map: Map
    var buildings: [BuildingConfig]
    var reports: [GrowthReport]
}

enum CityBuildingViewSelection {
    case Sentiment
    case Journal
}
