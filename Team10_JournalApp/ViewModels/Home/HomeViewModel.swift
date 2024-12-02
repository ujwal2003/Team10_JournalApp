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
    @Published var journalDataLoader: JournalDaysIDs = .init(sundayID: "", mondayID: "", tuesdayID: "", wednesdayID: "", thursdayID: "", fridayID: "", saturdayID: "")
    
    @Published var isRecommendedActionsShowing: Bool = false
    @Published var recommendedActions: [RecommendedAction] = []
    
    @Published var isGrowthReportShowing: Bool = false
    @Published var selectedBuildingIndex: Int = 0
    @Published var selectedBuildingDate: Date = Date()
    @Published var selectedJournalID: String = ""
    
    @Published var areNavigationButtonsDisabled: Bool = false
    
    func resetToLoadingState() {
        self.currMap = .LoadingMap
        self.currCityBlockBuildings = []
        self.journalDataLoader = .init(sundayID: "", mondayID: "", tuesdayID: "", wednesdayID: "", thursdayID: "", fridayID: "", saturdayID: "")
        
        self.selectedBuildingIndex = 0
        self.selectedBuildingDate = Date()
        self.selectedJournalID = ""
    }
    
    func lazyLoadJournalEntry(buildingDayIndex: Int) {
        let fetchedWeek = CommonUtilities.util.getWeekStartEndDates(offset: self.weekOffset)
        let selectedDayID = DayID.getDayIDByInteger(dayIndex: buildingDayIndex) ?? .Sunday
        let selectedDate = CommonUtilities.util.getWeekDates(startDateOfWeek: fetchedWeek.startDate, dayOfWeek: selectedDayID)
        
        self.selectedBuildingDate = selectedDate
        
        self.selectedBuildingIndex = buildingDayIndex
        
        self.selectedJournalID = CommonUtilities.util.getJournalIdByDayIdKey(weekJournals: self.journalDataLoader, day: selectedDayID)
        
        self.isGrowthReportShowing.toggle()
    }
    
    /// For the current week, loads the user's journal map or creates one if it does not exist
    func loadOrCreateCurrentWeekMap(userId: String) async {
        let currWeek = CommonUtilities.util.getWeekStartEndDates()
        
        self.areNavigationButtonsDisabled = true
        self.resetToLoadingState()
        
        let fetchedCityData = try? await CityBlockManager.shared.getCityBlockData(
            userId: userId,
            weekStartDate: currWeek.startDate,
            weekEndDate: currWeek.endDate
        )
        
        let todayDate = CommonUtilities.util.getDateByOffset(offset: 0)
        let todayIndex = Calendar.current.component(.weekday, from: todayDate) - 1
        
        if let cityData = fetchedCityData {
            self.currMap = cityData.cityMap
            self.journalDataLoader = cityData.journalIDs
            
            self.currCityBlockBuildings = [
                .init(style: .LightBlueTower, onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 0)
                }),
                .init(style: .RedTower, onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 1)
                }),
                .init(style: .GreenTower, onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 2)
                }),
                .init(style: .LightBrownTower, onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 3)
                }),
                .init(style: .BrownTower, onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 4)
                }),
                .init(style: .LightGreenTower, onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 5)
                }),
                .init(style: .GreenTower, onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 6)
                })
            ]
            
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
            let emptyJournals: JournalDaysIDs = .init(sundayID: "", mondayID: "", tuesdayID: "", wednesdayID: "", thursdayID: "", fridayID: "", saturdayID: "")
            
            let newCityMap = CityBlockData(
                userId: userId,
                weekStartDate: currWeek.startDate,
                weekEndDate: currWeek.endDate,
                mapName: Map.Map4.rawValue,
                journalIDs: emptyJournals
            )
            
            try? await CityBlockManager.shared.createNewCityBlockMap(cityBlockData: newCityMap)
            
            self.currMap = newCityMap.cityMap
            self.journalDataLoader = emptyJournals
            
            self.currCityBlockBuildings = (0..<7).map({ index in
                    .init(style: .Scaffolding) {
                        self.lazyLoadJournalEntry(buildingDayIndex: index)
                    }
            })
            
            for index in 0..<7 {
                if index == todayIndex {
                    self.currCityBlockBuildings[index].style = .PurpleConstruction
                }
            }
        }
        
        self.areNavigationButtonsDisabled = false
        
    }
    
    func loadWeekMapByOffset(userId: String) async {
        if self.weekOffset == 0 {
            await self.loadOrCreateCurrentWeekMap(userId: userId)
            return
        }
        
        let fetchWeek = CommonUtilities.util.getWeekStartEndDates(offset: self.weekOffset)
        
        self.areNavigationButtonsDisabled = true
        self.resetToLoadingState()
        
        let fetchedCityData = try? await CityBlockManager.shared.getCityBlockData(
            userId: userId,
            weekStartDate: fetchWeek.startDate,
            weekEndDate: fetchWeek.endDate
        )
        
        if let cityData = fetchedCityData {
            self.currMap = cityData.cityMap
            self.journalDataLoader = cityData.journalIDs
            
            self.currCityBlockBuildings = [
                .init(style: .LightBlueTower, onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 0) }),
                .init(style: .RedTower, onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 1) }),
                .init(style: .GreenTower, onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 2) }),
                .init(style: .LightBrownTower, onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 3) }),
                .init(style: .BrownTower, onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 4) }),
                .init(style: .GreenTower, onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 5) }),
                .init(style: .LightGreenTower, onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 6) }),
            ]
            
            let dayIDs = [
                self.journalDataLoader.sundayID, self.journalDataLoader.mondayID, self.journalDataLoader.tuesdayID,
                self.journalDataLoader.wednesdayID, self.journalDataLoader.thursdayID, self.journalDataLoader.fridayID,
                self.journalDataLoader.saturdayID
            ]
            
            for (index, dayId) in dayIDs.enumerated() {
                if dayId == "" {
                    self.currCityBlockBuildings[index].style = .BlueRuin
                }
            }
            
        } else {
            self.currMap = .NotFoundMap
        }
        
        self.areNavigationButtonsDisabled = false
    }
    
    func navigateToPastWeek(userId: String) {
        Task {
            self.weekOffset -= 1
            print("[HOME WEEK OFFSET]: \(self.weekOffset)")
            await self.loadWeekMapByOffset(userId: userId)
        }
    }
    
    func navigateToFutureWeek(userId: String) {
        Task {
            self.weekOffset += 1
            print("[HOME WEEK OFFSET]: \(self.weekOffset)")
            await self.loadWeekMapByOffset(userId: userId)
        }
    }
    
}
