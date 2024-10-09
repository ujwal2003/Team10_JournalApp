//
//  HomeViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/9/24.
//

import Foundation
import SwiftUI

enum JournalWeather {
    case NoData
    case Sunny
    case Error
    //TODO: figure out all the weathers
}

class HomeViewModel: ObservableObject {
    // TODO: add variable for City Health
    @Published var weatherStatus: JournalWeather
    @Published var currWeek: String
    @Published var numFriends: Int
    
    init() {
        self.weatherStatus = .Sunny
        self.currWeek = "1/3/2024-1/9/2024"
        self.numFriends = 5
    }
    
    func getWeatherStatus() -> (name: String, icon: String, iconColor: Color) {
        switch weatherStatus {
            case .NoData:
                return (name: "No Data",
                        icon: "exclamationmark.arrow.trianglehead.2.clockwise.rotate.90",
                        iconColor: Color.gray)
            
            case .Sunny:
                return (name: "Sunny",
                        icon: "sun.max.fill",
                        iconColor: Color.yellow)
            
            default:
                return (name: "Error",
                        icon: "person.crop.circle.badge.exclamationmark",
                        iconColor: Color.red)
        }
    }
    
    func getCurrCityBlock() -> String {
        return currWeek
    }
    
    func getNumCityConnections() -> Int {
        return numFriends
    }
}
