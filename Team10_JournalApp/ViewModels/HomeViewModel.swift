//
//  HomeViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/9/24.
//

import Foundation
import SwiftUI
import MapKit

class HomeViewModel: ObservableObject {
    //FIXME: - these two will be set by the load / async function
    @Published var currCityJournal: CityMap = CityMap(map: .LoadingMap, buildings: [], reports: [])
    @Published var currCityBlock: String = "Loading.."
    
    @Published var weatherStatus: JournalWeather
    @Published var recommendedActions: [RecommendedAction]
    @Published var numFriends: Int
    
    @Published var isNavigateLoading: Bool = true
    @Published var isGrowthReportShowing: Bool = false
    @Published var isRecommendedActionsShowing: Bool = false
    @Published var selectedBuildingIndex: Int = 0
    @Published var selectedBuilding: Building = .PurpleConstruction
    
    
    @Published var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    private var currWeek: String = "0"
    
    init(weatherStatus: JournalWeather, recommendedActions: [RecommendedAction], numFriends: Int) {
        self.weatherStatus = weatherStatus
        self.recommendedActions = recommendedActions
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
    
    //FIXME: fetch from actual db
    func loadCityMap(week: String) async {
//        self.isNavigateLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isNavigateLoading = false
            
            let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
            
            let viewReport = { (idx: Int, building: Building) -> Void in
                self.selectedBuildingIndex = idx
                self.selectedBuilding = building
                self.isGrowthReportShowing.toggle()
            }
            
            if week == "0" {
                self.currCityBlock = "Oct 20, 2024-Oct 26, 2024"
                self.currCityJournal = .init(map: .Map3,
                                             buildings: [
                                                .init(style: .BlueTower, onClick: { viewReport(0, .BlueTower) }),
                                                .init(style: .RedTower, onClick: { viewReport(1, .RedTower) }),
                                                .init(style: .BrownTower, onClick: { viewReport(2, .BrownTower) }),
                                                .init(style: .GreenRuin, onClick: { viewReport(3, .GreenRuin) }),
                                                .init(style: .LightBlueTower, onClick: { viewReport(4, .LightBlueTower) }),
                                                .init(style: .LightGreenTower, onClick: { viewReport(5, .LightGreenTower) }),
                                                .init(style: .BrownConstruction, onClick: { viewReport(6, .BrownConstruction) }),
                                             ],
                                             reports: Array(repeating: .init(gratitudeSentiment: .Positive,
                                                                             gratitudeEntry: dummyText,
                                                                             learningSentiment: .Neutral,
                                                                             learningEntry: dummyText,
                                                                             thoughtSentiment: .Negative,
                                                                             thoughtEntry: dummyText),
                                                            count: 7))
            } else if week == "-1" {
                self.currCityBlock = "Oct 13, 2024-Oct 20, 2024"
                self.currCityJournal = .init(map: .Map1,
                                             buildings: [
                                                .init(style: .BlueTower, onClick: { viewReport(0, .BlueTower) }),
                                                .init(style: .GreenTower, onClick: { viewReport(1, .GreenTower) }),
                                                .init(style: .BrownTower, onClick: { viewReport(2, .BrownTower) }),
                                                .init(style: .RedTower, onClick: { viewReport(3, .RedTower) }),
                                                .init(style: .LightBlueTower, onClick: { viewReport(4, .LightBlueTower) }),
                                                .init(style: .LightGreenTower, onClick: { viewReport(5, .LightGreenTower) }),
                                                .init(style: .LightBrownTower, onClick: { viewReport(6, .LightBrownTower) }),
                                             ],
                                             reports: Array(repeating: .init(gratitudeSentiment: .Neutral,
                                                                             gratitudeEntry: dummyText,
                                                                             learningSentiment: .Neutral,
                                                                             learningEntry: dummyText,
                                                                             thoughtSentiment: .Negative,
                                                                             thoughtEntry: dummyText),
                                                            count: 7))
            } else if week == "1" {
                self.currCityBlock = "Oct 27, 2024-Nov 2, 2024"
                self.currCityJournal = .init(map: .Map4,
                                             buildings: [
                                                .init(style: .BlueTower, onClick: { viewReport(0, .BlueTower) }),
                                                .init(style: .GreenTower, onClick: { viewReport(1, .GreenTower) }),
                                                .init(style: .BrownTower, onClick: { viewReport(2, .BrownTower) }),
                                                .init(style: .RedTower, onClick: { viewReport(3, .RedTower) }),
                                                .init(style: .LightBlueTower, onClick: { viewReport(4, .LightBlueTower) }),
                                                .init(style: .LightGreenTower, onClick: { viewReport(5, .LightGreenTower) }),
                                                .init(style: .LightBrownTower, onClick: { viewReport(6, .LightBrownTower) }),
                                             ],
                                             reports: Array(repeating: .init(gratitudeSentiment: .Neutral,
                                                                             gratitudeEntry: dummyText,
                                                                             learningSentiment: .Neutral,
                                                                             learningEntry: dummyText,
                                                                             thoughtSentiment: .Negative,
                                                                             thoughtEntry: dummyText),
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
    
    //FIXME: fetch from actual db
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
