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
    //FIXME: - these two will be set by the load / async function
    @Published var currCityJournal: CityMap = CityMap(map: .LoadingMap, buildings: [], reports: [])
    @Published var currCityBlock: String = "Loading.."
    
    @Published var weatherStatus: JournalWeather
    @Published var numFriends: Int
    
    @Published var isNavigateLoading: Bool = false
    @Published var isGrowthReportShowing: Bool = false
    @Published var selectedBuildingIndex: Int = 0
    
    
    @Published var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    private var currWeek: String = "0"
    
    init(weatherStatus: JournalWeather, numFriends: Int) {
        self.weatherStatus = weatherStatus
        self.numFriends = numFriends
        
        Task {
            await loadCityMap(week: currWeek)
        }
    }
    
    //FIXME: use db data instead to calculate from date
    func calcCityHealthPercentage() -> CGFloat {
        return 1.0
    }
    
    func getCityHealthColors() -> (borderColor: Color, barColor: Color) {
        let cityHealthPercentage = self.calcCityHealthPercentage()
        
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
    
    //FIXME: fetch from actual db
    func loadCityMap(week: String) async {
        self.isNavigateLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isNavigateLoading = false
            
            let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
            
            let viewReport = { (idx: Int) -> Void in
                self.selectedBuildingIndex = idx
                self.isGrowthReportShowing.toggle()
            }
            
            if week == "0" {
                self.currCityBlock = "Oct 20, 2024-Oct 26, 2024"
                self.currCityJournal = .init(map: .Map3,
                                             buildings: [
                                                .init(style: .BlueTower, onClick: { viewReport(0) }),
                                                .init(style: .RedTower, onClick: { viewReport(1) }),
                                                .init(style: .BrownTower, onClick: { viewReport(2) }),
                                                .init(style: .GreenTower, onClick: { viewReport(3) }),
                                                .init(style: .LightBlueTower, onClick: { viewReport(4) }),
                                                .init(style: .LightGreenTower, onClick: { viewReport(5) }),
                                                .init(style: .LightBrownTower, onClick: { viewReport(6) }),
                                             ],
                                             reports: Array(repeating: .init(gratitudeSentiment: .Positive,
                                                                             gratitudeReport: dummyText,
                                                                             learningSentiment: .Neutral,
                                                                             learningReport: dummyText,
                                                                             thoughtSentiment: .Negative,
                                                                             thoughtReport: dummyText),
                                                            count: 7))
            } else if week == "-1" {
                self.currCityBlock = "Oct 13, 2024-Oct 20, 2024"
                self.currCityJournal = .init(map: .Map1,
                                             buildings: [
                                                .init(style: .BlueTower, onClick: { viewReport(0) }),
                                                .init(style: .GreenTower, onClick: { viewReport(1) }),
                                                .init(style: .BrownTower, onClick: { viewReport(2) }),
                                                .init(style: .RedTower, onClick: { viewReport(3) }),
                                                .init(style: .LightBlueTower, onClick: { viewReport(4) }),
                                                .init(style: .LightGreenTower, onClick: { viewReport(5) }),
                                                .init(style: .LightBrownTower, onClick: { viewReport(6) }),
                                             ],
                                             reports: Array(repeating: .init(gratitudeSentiment: .Neutral,
                                                                             gratitudeReport: dummyText,
                                                                             learningSentiment: .Neutral,
                                                                             learningReport: dummyText,
                                                                             thoughtSentiment: .Negative,
                                                                             thoughtReport: dummyText),
                                                            count: 7))
            } else if week == "1" {
                self.currCityBlock = "Oct 27, 2024-Nov 2, 2024"
                self.currCityJournal = .init(map: .Map4,
                                             buildings: [
                                                .init(style: .BlueTower, onClick: { viewReport(0) }),
                                                .init(style: .GreenTower, onClick: { viewReport(1) }),
                                                .init(style: .BrownTower, onClick: { viewReport(2) }),
                                                .init(style: .RedTower, onClick: { viewReport(3) }),
                                                .init(style: .LightBlueTower, onClick: { viewReport(4) }),
                                                .init(style: .LightGreenTower, onClick: { viewReport(5) }),
                                                .init(style: .LightBrownTower, onClick: { viewReport(6) }),
                                             ],
                                             reports: Array(repeating: .init(gratitudeSentiment: .Neutral,
                                                                             gratitudeReport: dummyText,
                                                                             learningSentiment: .Neutral,
                                                                             learningReport: dummyText,
                                                                             thoughtSentiment: .Negative,
                                                                             thoughtReport: dummyText),
                                                            count: 7))
            } else {
                self.currCityBlock = "*** **, ****-*** **, ****"
                self.currCityJournal = .init(map: .NotFoundMap,
                                             buildings: [],
                                             reports: [])
            }
        }
    }
    
    //FIXME: fetch from actual db
    func getFutureCity() async {
        self.currCityJournal = CityMap(map: .LoadingMap, buildings: [], reports: [])
        self.currCityBlock = "Loading..."
        
        if let num = Int(self.currWeek) {
            self.currWeek = String(num + 1)
        } else {
            currWeek = "0"
        }
        
        await loadCityMap(week: self.currWeek)
    }
    
    func getPastCity() async {
        self.currCityJournal = CityMap(map: .LoadingMap, buildings: [], reports: [])
        self.currCityBlock = "Loading..."
        
        if let num = Int(self.currWeek) {
            self.currWeek = String(num - 1)
        } else {
            currWeek = "0"
        }
        
        await loadCityMap(week: self.currWeek)
    }
}
