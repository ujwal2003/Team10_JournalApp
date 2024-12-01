//
//  HomeViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/18/24.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var weekOffset: Int = 0
    @Published var currWeek: String = "XX/XX/XX - XX/XX/XX"
    @Published var numFriends: Int = 0
    
    @Published var cityHealthPercentage: CGFloat = 0.0
    @Published var currSentimentWeather: JournalWeather = .NoData
    
    @Published var currMap: Map = .LoadingMap
    @Published var currCityBlockBuildings: [BuildingConfig] = []
    @Published var currWeekJournal: [GrowthReport] = []
    @Published var journalDataLoader: JournalDaysIDs = .init(sundayID: "", mondayID: "", tuesdayID: "", wednesdayID: "", thursdayID: "", fridayID: "", saturdayID: "")
    @Published var fetchedJournalEntry: JournalEntry?
    
    @Published var isRecommendedActionsShowing: Bool = false
    @Published var recommendedActions: [RecommendedAction] = []
    
    @Published var isGrowthReportShowing: Bool = false
    @Published var selectedBuildingIndex: Int = 0
    
    
    func loadOrCreateCurrentWeekMap(userId: String) async {
        let currWeek = CommonUtilities.util.getWeekStartEndDates()
        
        let fetchedCityData = try? await CityBlockManager.shared.getCityBlockData(
            userId: userId,
            weekStartDate: currWeek.startDate,
            weekEndDate: currWeek.endDate
        )
        
        if let cityData = fetchedCityData {
            self.currMap = cityData.cityMap
            self.journalDataLoader = cityData.journalIDs
            
            self.currWeekJournal = Array(
                repeating: .init(
                    gratitudeSentiment: .Loading,
                    gratitudeEntry: "Loading...",
                    learningSentiment: .Loading,
                    learningEntry: "Loading...",
                    thoughtSentiment: .Loading,
                    thoughtEntry: "Loading..."
                ),
                count: 7
            )
            
            self.currCityBlockBuildings = [
                .init(style: .LightBlueTower, onClick: {
                    self.selectedBuildingIndex = 0
                    self.isGrowthReportShowing.toggle()
                }),
                .init(style: .RedTower, onClick: {
                    self.selectedBuildingIndex = 1
                    self.isGrowthReportShowing.toggle()
                }),
                .init(style: .GreenTower, onClick: {
                    self.selectedBuildingIndex = 2
                    self.isGrowthReportShowing.toggle()
                }),
                .init(style: .LightBrownTower, onClick: {
                    self.selectedBuildingIndex = 3
                    self.isGrowthReportShowing.toggle()
                }),
                .init(style: .BrownTower, onClick: {
                    self.selectedBuildingIndex = 4
                    self.isGrowthReportShowing.toggle()
                }),
                .init(style: .LightGreenTower, onClick: {
                    self.selectedBuildingIndex = 5
                    self.isGrowthReportShowing.toggle()
                }),
                .init(style: .GreenTower, onClick: {
                    self.selectedBuildingIndex = 6
                    self.isGrowthReportShowing.toggle()
                })
            ]
            
            let todayDate = CommonUtilities.util.getDateByOffset(offset: 0)
            let todayIndex = Calendar.current.component(.weekday, from: todayDate) - 1

            
            let dayIDs = [
                self.journalDataLoader.sundayID, self.journalDataLoader.mondayID, self.journalDataLoader.tuesdayID,
                self.journalDataLoader.wednesdayID, self.journalDataLoader.thursdayID, self.journalDataLoader.fridayID,
                self.journalDataLoader.saturdayID
            ]
            
            for (index, dayId) in dayIDs.enumerated() {
                if dayId == "" {
                    if index == todayIndex { // Today should be construction
                        self.currCityBlockBuildings[index].style = .YellowConstruction
                        
                    } else if index < todayIndex { // Skipped days should be ruins
                        self.currCityBlockBuildings[index].style = .RedRuin
                        
                    } else { // Future days should be scaffolding
                        self.currCityBlockBuildings[index].style = .Scaffolding
                    }
                }
            }
            
        } else { // create new city map
            // TODO: create new city map and upload to db
        }
        
    }
    
}
