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

enum Sentiment {
    case Positive
    case Neutral
    case Negative
    
    var textView: Text {
        switch self {
            case .Positive:
                return Text("Positive")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#5EB881"))
            
            case .Neutral:
                return Text("Neutral")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#8A8A8A"))
            
            case .Negative:
                return Text("Negative")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#DE5353"))
        }
    }
}

struct GrowthReport {
    var gratitudeSentiment: Sentiment
    var gratitudeReport: String
    
    var learningSentiment: Sentiment
    var learningReport: String
    
    var thoughtSentiment: Sentiment
    var thoughtReport: String
}

struct CityMap {
    var map: Map
    var buildings: [BuildingConfig]
    var reports: [GrowthReport]
}

class HomeViewModel: ObservableObject {
    @Published var cityHealthPercentage: CGFloat
    @Published var weatherStatus: JournalWeather
    @Published var numFriends: Int
    
    @Published var dummyWeek: Int //FIXME: replace with db data
    
    @Published var isNavigateLoading: Bool = false
    @Published var isGrowthReportShowing: Bool = false
    @Published var selectedGrowthReportIndex: Int = 0
    @Published var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    
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
        let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        
        let dummyData: [CityMap] = [
            .init(map: .Map2,
                  buildings: [
                    .init(style: .BlueTower, onClick: {
                        self.selectedGrowthReportIndex = 0
                        self.isGrowthReportShowing.toggle()
                    }),
                    .init(style: .BrownTower, onClick: {
                        self.selectedGrowthReportIndex = 1
                        self.isGrowthReportShowing.toggle()
                    }),
                    .init(style: .GreenTower, onClick: {
                        self.selectedGrowthReportIndex = 2
                        self.isGrowthReportShowing.toggle()
                    }),
                    .init(style: .LightBlueTower, onClick: {
                        self.selectedGrowthReportIndex = 3
                        self.isGrowthReportShowing.toggle()
                    }),
                    .init(style: .LightBrownTower, onClick: {
                        self.selectedGrowthReportIndex = 4
                        self.isGrowthReportShowing.toggle()
                    }),
                    .init(style: .LightGreenTower, onClick: {
                        self.selectedGrowthReportIndex = 5
                        self.isGrowthReportShowing.toggle()
                    }),
                    .init(style: .RedTower, onClick: {
                        self.selectedGrowthReportIndex = 6
                        self.isGrowthReportShowing.toggle()
                    })
                  ],
                  reports: Array(repeating: .init(gratitudeSentiment: .Positive,
                                                  gratitudeReport: dummyText,
                                                  learningSentiment: .Neutral,
                                                  learningReport: dummyText,
                                                  thoughtSentiment: .Negative,
                                                  thoughtReport: dummyText),
                                 count: 7)),
            
                .init(map: .Map3,
                      buildings: [
                        .init(style: .BlueTower, onClick: {
                            self.selectedGrowthReportIndex = 0
                            self.isGrowthReportShowing.toggle()
                        }),
                        .init(style: .BrownTower, onClick: {
                            self.selectedGrowthReportIndex = 1
                            self.isGrowthReportShowing.toggle()
                        }),
                        .init(style: .GreenTower, onClick: {
                            self.selectedGrowthReportIndex = 2
                            self.isGrowthReportShowing.toggle()
                        }),
                        .init(style: .LightBlueTower, onClick: {
                            self.selectedGrowthReportIndex = 3
                            self.isGrowthReportShowing.toggle()
                        }),
                        .init(style: .LightBrownTower, onClick: {
                            self.selectedGrowthReportIndex = 4
                            self.isGrowthReportShowing.toggle()
                        }),
                        .init(style: .LightGreenTower, onClick: {
                            self.selectedGrowthReportIndex = 5
                            self.isGrowthReportShowing.toggle()
                        }),
                        .init(style: .RedTower, onClick: {
                            self.selectedGrowthReportIndex = 6
                            self.isGrowthReportShowing.toggle()
                        })
                      ],
                      reports: Array(repeating: .init(gratitudeSentiment: .Positive,
                                                      gratitudeReport: dummyText,
                                                      learningSentiment: .Neutral,
                                                      learningReport: dummyText,
                                                      thoughtSentiment: .Negative,
                                                      thoughtReport: dummyText),
                                     count: 7))
        ]
        
        return dummyData[week]
    }
    
    //FIXME: dummy implementation for now
    func getNextWeekMap() {
        isNavigateLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isNavigateLoading = false
            self.dummyWeek = self.dummyWeek == 1 ? 0 : self.dummyWeek + 1
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
