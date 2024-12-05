//
//  FriendCheckInViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/28/24.
//

import Foundation

@MainActor
class FriendCheckInViewModel: ObservableObject {
    @Published var friendCityMap: Map = .LoadingMap
    @Published var friendSentimentWeather: JournalWeather = .NoData
    @Published var friendCityBlockBuildings: [BuildingConfig] = []
    
    @Published var journalDataLoader: JournalDaysIDs = .init(sundayID: "", mondayID: "", tuesdayID: "", wednesdayID: "", thursdayID: "", fridayID: "", saturdayID: "")
    
    @Published var isGrowthReportShowing: Bool = false
    @Published var selectedBuildingIndex: Int = 0
    @Published var selectedBuildingDate: Date = Date()
    @Published var selectedJournalID: String = ""
    
    func resetToLoadingState() {
        self.friendCityMap = .LoadingMap
        self.friendCityBlockBuildings = []
        self.journalDataLoader = .init(sundayID: "", mondayID: "", tuesdayID: "", wednesdayID: "", thursdayID: "", fridayID: "", saturdayID: "")
        
        self.selectedBuildingIndex = 0
        self.selectedBuildingDate = Date()
        self.selectedJournalID = ""
    }
    
    func lazyLoadJournalEntry(buidlingDayIndex: Int) {
        let currWeek = CommonUtilities.util.getWeekStartEndDates()
        let selectedDayID = DayID.getDayIDByInteger(dayIndex: buidlingDayIndex) ?? .Sunday
        let selectedDate = CommonUtilities.util.getWeekDates(startDateOfWeek: currWeek.startDate, dayOfWeek: selectedDayID)
        
        self.selectedBuildingDate = selectedDate
        self.selectedBuildingIndex = buidlingDayIndex
        self.selectedJournalID = CommonUtilities.util.getJournalIdByDayIdKey(weekJournals: self.journalDataLoader, day: selectedDayID)
        self.isGrowthReportShowing.toggle()
    }
    
    func loadFriendCurrentWeekMap(friendUserId: String) async {
        let currWeek = CommonUtilities.util.getWeekStartEndDates()
        let util = CommonUtilities.util
        
        self.resetToLoadingState()
        
        let fetchCityData = try? await CityBlockManager.shared.getCityBlockData(
            userId: friendUserId,
            weekStartDate: currWeek.startDate,
            weekEndDate: currWeek.endDate
        )
        
        let todayDate = util.getDateByOffset(offset: 0)
        let todayIndex = Calendar.current.component(.weekday, from: todayDate) - 1
        
        if let cityData = fetchCityData {
            self.friendCityMap = cityData.cityMap
            self.journalDataLoader = cityData.journalIDs
            
            self.friendCityBlockBuildings = [
                .init(style: util.towers[0], onClick: {
                    self.lazyLoadJournalEntry(buidlingDayIndex: 0)
                }),
                .init(style: util.towers[2], onClick: {
                    self.lazyLoadJournalEntry(buidlingDayIndex: 1)
                }),
                .init(style: util.towers[1], onClick: {
                    self.lazyLoadJournalEntry(buidlingDayIndex: 2)
                }),
                .init(style: util.towers[4], onClick: {
                    self.lazyLoadJournalEntry(buidlingDayIndex: 3)
                }),
                .init(style: util.towers[3], onClick: {
                    self.lazyLoadJournalEntry(buidlingDayIndex: 4)
                }),
                .init(style: util.towers[6], onClick: {
                    self.lazyLoadJournalEntry(buidlingDayIndex: 5)
                }),
                .init(style: util.towers[5], onClick: {
                    self.lazyLoadJournalEntry(buidlingDayIndex: 6)
                })
            ]
            
            let dayIDs = [
                self.journalDataLoader.sundayID, self.journalDataLoader.mondayID, self.journalDataLoader.tuesdayID,
                self.journalDataLoader.wednesdayID, self.journalDataLoader.thursdayID, self.journalDataLoader.fridayID,
                self.journalDataLoader.saturdayID
            ]
            
            for (index, dayId) in dayIDs.enumerated() {
                if dayId == "" {
                    if index == todayIndex {
                        self.friendCityBlockBuildings[index].style = util.constructions[(dayIDs.count - 1) - index]
                        
                    } else if index < todayIndex {
                        self.friendCityBlockBuildings[index].style = util.ruins[index]
                        
                    } else {
                        self.friendCityBlockBuildings[index].style = .Scaffolding
                    }
                }
            }
            
        } else {
            self.friendCityMap = .NotFoundMap
        }
    }
    
}
