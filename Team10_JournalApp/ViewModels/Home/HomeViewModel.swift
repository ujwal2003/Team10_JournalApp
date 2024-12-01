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
    
    func getJournalBuildingView(userId: String) -> CityJournalBuildingView {
        let day = "\(dayToIndex[self.selectedBuildingIndex] ?? "Day")"
        let selectedBuilding = self.currCityBlockBuildings[self.selectedBuildingIndex].style
        
        var growthHeadline: String {
            if selectedBuilding.category == .Ruin {
                return "Ruins of \(day)"
            }
            
            return "\(day) City Growth"
        }
        
//        let dayIDs = [
//            self.journalDataLoader.sundayID, self.journalDataLoader.mondayID, self.journalDataLoader.tuesdayID,
//            self.journalDataLoader.wednesdayID, self.journalDataLoader.thursdayID, self.journalDataLoader.fridayID,
//            self.journalDataLoader.saturdayID
//        ]
        
//        let journalFetchID = dayIDs[self.selectedBuildingIndex]
        
        Task {
            do {
                let decodedDayFromInteger = DayID.getDayIDByInteger(dayIndex: self.selectedBuildingIndex)
                
                if let decodedDay = decodedDayFromInteger {
                    let fetchWeek = CommonUtilities.util.getWeekStartEndDates(offset: self.weekOffset)
                    
                    let fetchDate = CommonUtilities.util.getWeekDates(
                        startDateOfWeek: fetchWeek.startDate,
                        dayOfWeek: decodedDay
                    )
                    
                    let entry = try await JournalManager.shared.getJournalEntry(userId: userId, date: fetchDate)
                    
                    DispatchQueue.main.async {
                        self.fetchedJournalEntry = entry
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.fetchedJournalEntry = .init(
                        userId: "",
                        dateCreated: Date(),
                        gratitudeEntry: "ERROR",
                        gratitudeSentiment: "ERROR",
                        learningEntry: "ERROR",
                        learningSentiment: "ERROR",
                        thoughtEntry: "ERROR",
                        thoughtSentiment: "ERROR"
                    )
                }
            }
        }
        
        let currWeekJournal = self.currWeekJournal
        
        if !currWeekJournal.isEmpty {
            return CityJournalBuildingView(
                headlineTitle: growthHeadline,
                building: selectedBuilding,
                growthReport: GrowthReport(
                    gratitudeSentiment: .Loading,
                    gratitudeEntry: fetchedJournalEntry?.gratitudeEntry ?? "Loading entry...",
                    learningSentiment: .Loading,
                    learningEntry: fetchedJournalEntry?.learningEntry ?? "Loading entry...",
                    thoughtSentiment: .Loading,
                    thoughtEntry: fetchedJournalEntry?.thoughtEntry ?? "Loading entry..."
                )
            )
        }
        
        return CityJournalBuildingView(
            headlineTitle: growthHeadline,
            building: selectedBuilding,
            growthReport: .init(
                gratitudeSentiment: .Error,
                gratitudeEntry: "ERROR",
                learningSentiment: .Error,
                learningEntry: "ERROR",
                thoughtSentiment: .Error,
                thoughtEntry: "ERROR"
            )
        )
    }
    
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
