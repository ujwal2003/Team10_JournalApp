//
//  HomeViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/9/24.
//

import Foundation
import SwiftUI

enum JournalWeather {
    case Sunny
    case Cloudy
    case Drizzle
    case Rain
    case Stormy
    case NoData
    case Error
}

struct CityMap {
    var map: Map
    var buildings: [BuildingConfig]
}

class HomeViewModel: ObservableObject {
    @Published var cityHealthPercentage: CGFloat
    @Published var weatherStatus: JournalWeather
    @Published var numFriends: Int
    
    @Published var dummyWeek: Int //FIXME: replace with db data
    
    @Published var isNavigateLoading: Bool = false
    
    
    init(cityHealthPercentage: CGFloat, weatherStatus: JournalWeather, numFriends: Int, dummyWeek: Int) {
        self.cityHealthPercentage = cityHealthPercentage
        self.weatherStatus = weatherStatus
        self.numFriends = numFriends
        self.dummyWeek = dummyWeek
    }
    
    func getWeatherStatus() -> (name: String, icon: String, iconWidth: CGFloat, iconColor: Color) {
        switch weatherStatus {
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
                return (name: "Rain",
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
    
    func getCityHealthColors() -> (borderColor: Color, barColor: Color) {
        if cityHealthPercentage >= 0.75 {
            return (borderColor: Color(red: 0, green: 0.66, blue: 0.39).opacity(0.4),
                    barColor: Color(red: 0.79, green: 1, blue: 0.87))
            
        } else if cityHealthPercentage >= 0.50 {
            return (borderColor: Color(red: 0.84, green: 0.86, blue: 0.01).opacity(0.53),
                    barColor: Color(red: 0.98, green: 1, blue: 0.79))
            
        } else if cityHealthPercentage >= 0.25 {
            return (borderColor: Color(red: 0.66, green: 0.46, blue: 0).opacity(0.4),
                    barColor: Color(red: 1, green: 0.94, blue: 0.79))
        }
        
        return (borderColor: Color(red: 0.66, green: 0.16, blue: 0).opacity(0.4),
                barColor: Color(red: 1, green: 0.84, blue: 0.79))
    }
    
    func getCurrCityBlock() -> String {
        return getCurrentWeek()
    }
    
    func getCurrentWeek() -> String {
        let calendar = Calendar.current
        let date = Date()
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start
        let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.end
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let startStr = formatter.string(from: startOfWeek ?? Date())
        let endStr = formatter.string(from: endOfWeek ?? Date())
        
        return "\(startStr)-\(endStr)"
    }
    
    //FIXME: dummy data & implementation for now
    func getCityMap(week: Int) -> CityMap {
        let dummyData: [CityMap] = [
            .init(map: .Map2, buildings: [
                .init(style: .BlueTower, onClick: {}),
                .init(style: .BrownTower, onClick: {}),
                .init(style: .GreenTower, onClick: {}),
                .init(style: .LightBlueTower, onClick: {}),
                .init(style: .LightBrownTower, onClick: {}),
                .init(style: .LightGreenTower, onClick: {}),
                .init(style: .RedTower, onClick: {})
            ]),
            
            .init(map: .Map4, buildings: [
                .init(style: .BrownTower, onClick: {}),
                .init(style: .BlueTower, onClick: {}),
                .init(style: .GreenTower, onClick: {}),
                .init(style: .LightBrownTower, onClick: {}),
                .init(style: .LightGreenTower, onClick: {}),
                .init(style: .LightBlueTower, onClick: {}),
                .init(style: .RedTower, onClick: {})
            ]),
            
            .init(map: .Map1, buildings: [
                .init(style: .GreenTower, onClick: {}),
                .init(style: .BrownTower, onClick: {}),
                .init(style: .BlueTower, onClick: {}),
                .init(style: .LightBrownTower, onClick: {}),
                .init(style: .LightBlueTower, onClick: {}),
                .init(style: .LightGreenTower, onClick: {}),
                .init(style: .RedTower, onClick: {})
            ]),
            
            .init(map: .Map3, buildings: [
                .init(style: .BrownTower, onClick: {}),
                .init(style: .GreenTower, onClick: {}),
                .init(style: .LightBrownTower, onClick: {}),
                .init(style: .LightBlueTower, onClick: {}),
                .init(style: .BlueTower, onClick: {}),
                .init(style: .LightGreenTower, onClick: {}),
                .init(style: .RedTower, onClick: {})
            ]),
            
            .init(map: .Map2, buildings: [
                .init(style: .BrownTower, onClick: {}),
                .init(style: .LightBlueTower, onClick: {}),
                .init(style: .GreenTower, onClick: {}),
                .init(style: .LightBrownTower, onClick: {}),
                .init(style: .LightGreenTower, onClick: {}),
                .init(style: .BlueTower, onClick: {}),
                .init(style: .RedTower, onClick: {})
            ])
        ]
        
        return dummyData[week]
    }
    
    //FIXME: dummy implementation for now
    func getNextWeekMap() {
        isNavigateLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isNavigateLoading = false
            self.dummyWeek = self.dummyWeek == 4 ? 0 : self.dummyWeek + 1
        }
    }
    
    //FIXME: dummy implementation for now
    func getPrevWeekMap() {
        isNavigateLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.isNavigateLoading = false
            self.dummyWeek = self.dummyWeek == 0 ? 0 : self.dummyWeek - 1
        }
    }
}
