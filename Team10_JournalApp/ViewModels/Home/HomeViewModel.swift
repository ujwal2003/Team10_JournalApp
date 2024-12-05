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
        let util = CommonUtilities.util
        let currWeek = util.getWeekStartEndDates()
        
        self.areNavigationButtonsDisabled = true
        self.resetToLoadingState()
        
        let fetchedCityData = try? await CityBlockManager.shared.getCityBlockData(
            userId: userId,
            weekStartDate: currWeek.startDate,
            weekEndDate: currWeek.endDate
        )
        
        let todayDate = util.getDateByOffset(offset: 0)
        let todayIndex = Calendar.current.component(.weekday, from: todayDate) - 1
        
        if let cityData = fetchedCityData {
            self.currMap = cityData.cityMap
            self.journalDataLoader = cityData.journalIDs
            
            self.currCityBlockBuildings = [
                .init(style: util.towers[0], onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 0)
                }),
                .init(style: util.towers[1], onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 1)
                }),
                .init(style: util.towers[2], onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 2)
                }),
                .init(style: util.towers[3], onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 3)
                }),
                .init(style: util.towers[4], onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 4)
                }),
                .init(style: util.towers[5], onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 5)
                }),
                .init(style: util.towers[6], onClick: {
                    self.lazyLoadJournalEntry(buildingDayIndex: 6)
                })
            ]
            
            let dayIDs = [
                self.journalDataLoader.sundayID, self.journalDataLoader.mondayID, self.journalDataLoader.tuesdayID,
                self.journalDataLoader.wednesdayID, self.journalDataLoader.thursdayID, self.journalDataLoader.fridayID,
                self.journalDataLoader.saturdayID
            ]
            
            // no journals saved for these dates
            for (index, dayId) in dayIDs.enumerated() {
                if dayId == "" {
                    if index == todayIndex { // Today should be construction
                        self.currCityBlockBuildings[index].style = util.getBuildingStyle(.Construction)
                        
                    } else if index < todayIndex { // Skipped days should be ruins
                        self.currCityBlockBuildings[index].style = util.ruins[index]
                        
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
                mapName: util.getMapStyle().rawValue,
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
                    self.currCityBlockBuildings[index].style = util.constructions[index]
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
        
        let util = CommonUtilities.util
        let fetchWeek = util.getWeekStartEndDates(offset: self.weekOffset)
        
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
                .init(style: util.towers[6], onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 0) }),
                .init(style: util.towers[5], onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 1) }),
                .init(style: util.towers[4], onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 2) }),
                .init(style: util.towers[3], onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 3) }),
                .init(style: util.towers[2], onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 4) }),
                .init(style: util.towers[1], onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 5) }),
                .init(style: util.towers[0], onClick: { self.lazyLoadJournalEntry(buildingDayIndex: 6) }),
            ]
            
            let dayIDs = [
                self.journalDataLoader.sundayID, self.journalDataLoader.mondayID, self.journalDataLoader.tuesdayID,
                self.journalDataLoader.wednesdayID, self.journalDataLoader.thursdayID, self.journalDataLoader.fridayID,
                self.journalDataLoader.saturdayID
            ]
            
            // skipped days are ruins
            for (index, dayId) in dayIDs.enumerated() {
                if dayId == "" {
                    self.currCityBlockBuildings[index].style = util.ruins[(dayIDs.count - 1) - index]
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
            
            self.currWeek = CommonUtilities.util.getWeekRange(offset: self.weekOffset)
            await self.loadWeekMapByOffset(userId: userId)
        }
    }
    
    func navigateToFutureWeek(userId: String) {
        Task {
            self.weekOffset += 1
            print("[HOME WEEK OFFSET]: \(self.weekOffset)")
            
            self.currWeek = CommonUtilities.util.getWeekRange(offset: self.weekOffset)
            await self.loadWeekMapByOffset(userId: userId)
        }
    }
    
    func getActionsBasedOnSentiment(sentiment: Sentiment) -> [RecommendedAction] {
        let util = CommonUtilities.util
        
        switch sentiment {
        case .Positive:
            let creativeSpace = util.getRandomEnumValues(from: CreativeSpaces.self, count: 1)[0]
            let enjoyableExperience = util.getRandomEnumValues(from: EnjoyableExperiences.self, count: 1)[0]
            let interactiveVenue = util.getRandomEnumValues(from: InteractiveVenues.self, count: 1)[0]
            let sereneEnvironment = util.getRandomEnumValues(from: SereneEnvironments.self, count: 1)[0]
            let foodPlace = util.getRandomEnumValues(from: FoodPlaces.self, count: 1)[0]
            
            return [
                creativeSpace.mapActionSearch, enjoyableExperience.mapActionSearch, interactiveVenue.mapActionSearch,
                sereneEnvironment.mapActionSearch, foodPlace.mapActionSearch
            ]
            
        case .Fair:
            let creativeSpaces = util.getRandomEnumValues(from: CreativeSpaces.self, count: 2)
            let enjoyableExperience = util.getRandomEnumValues(from: EnjoyableExperiences.self, count: 1)[0]
            let interactiveVenue = util.getRandomEnumValues(from: InteractiveVenues.self, count: 1)[0]
            
            return [
                creativeSpaces[0].mapActionSearch, enjoyableExperience.mapActionSearch,
                interactiveVenue.mapActionSearch, creativeSpaces[1].mapActionSearch
            ]
            
        case .Neutral:
            let sereneEnvironments = util.getRandomEnumValues(from: SereneEnvironments.self, count: 3)
            let interactiveVenue = util.getRandomEnumValues(from: InteractiveVenues.self, count: 1)[0]
            
            return [
                sereneEnvironments[0].mapActionSearch, sereneEnvironments[1].mapActionSearch,
                interactiveVenue.mapActionSearch, sereneEnvironments[2].mapActionSearch
            ]
            
        case .Concerning:
            let interactiveVenues = util.getRandomEnumValues(from: InteractiveVenues.self, count: 2)
            let sereneEnvironments = util.getRandomEnumValues(from: SereneEnvironments.self, count: 2)
            
            return [
                interactiveVenues[0].mapActionSearch, sereneEnvironments[0].mapActionSearch,
                interactiveVenues[1].mapActionSearch, sereneEnvironments[1].mapActionSearch
            ]
            
        case .Negative:
            let foodPlaces = util.getRandomEnumValues(from: FoodPlaces.self, count: 2)
            
            return [
                EnjoyableExperiences.Parks.mapActionSearch, EnjoyableExperiences.Cafes.mapActionSearch, SereneEnvironments.Trails.mapActionSearch,
                foodPlaces[0].mapActionSearch, foodPlaces[1].mapActionSearch
            ]
            
        default:
            return []
        }
    }
    
    func computeCityHealth(userId: String) async {
        let expectedCityCount = 2
        
        let prevWeek = CommonUtilities.util.getWeekStartEndDates(offset: -1)
        let currWeek = CommonUtilities.util.getWeekStartEndDates(offset: 0)
        
        let fetchCitiesCount = try? await CityBlockManager.shared.getCountOfCitiesForDateRange(
            userId: userId,
            searchStartDate: prevWeek.startDate,
            searchEndDate: currWeek.endDate
        )
        
        let fetchSkippedJournalsCount = try? await CityBlockManager.shared.getCountOfSkippedEntriesFromCitiesOnDateRange(
            userId: userId,
            searchStartDate: prevWeek.startDate,
            searchEndDate: currWeek.endDate
        )
        
        let fetchUserStartDate = try? await CityBlockManager.shared.getEarliestStartDate(userId: userId)
        
        var healthPercentage = 1.0
        
        if let citiesCount = fetchCitiesCount {
            if citiesCount < expectedCityCount {
                healthPercentage -= 0.35
            }
            
            if let journalsSkippedCount = fetchSkippedJournalsCount {
                healthPercentage -= (Double(journalsSkippedCount) * 0.02)
                
            } else {
                healthPercentage -= 0.5
            }
            
        } else {
            healthPercentage -= 0.5
        }
        
        if let userStartDate = fetchUserStartDate {
            if userStartDate >= currWeek.startDate && userStartDate <= currWeek.startDate {
                healthPercentage += 0.65
                
            } else if userStartDate >= prevWeek.startDate && userStartDate <= currWeek.startDate {
                healthPercentage += 0.15
            }
        } else {
            healthPercentage = 1.0
        }
        
        let clampedPercentage = min(max(healthPercentage, 0.0), 1.0)
        self.cityHealthPercentage = clampedPercentage
    }
}
