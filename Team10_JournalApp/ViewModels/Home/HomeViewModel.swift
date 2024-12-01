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
    
    @Published var isRecommendedActionsShowing: Bool = false
    @Published var recommendedActions: [RecommendedAction] = []
    
    @Published var isGrowthReportShowing: Bool = false
    @Published var selectedBuildingIndex: Int = 0
    
    func getJournalBuildingView() -> CityJournalBuildingView {
        let day = "\(dayToIndex[self.selectedBuildingIndex] ?? "Day")"
        let selectedBuilding = self.currCityBlockBuildings[self.selectedBuildingIndex].style
        
        var growthHeadline: String {
            if selectedBuilding.category == .Ruin {
                return "Ruins of \(day)"
            }
            
            return "\(day) City Growth"
        }
        
        let currWeekJournal = self.currWeekJournal
        if !currWeekJournal.isEmpty {
            return CityJournalBuildingView(
                headlineTitle: growthHeadline,
                building: selectedBuilding,
                growthReport: self.currWeekJournal[self.selectedBuildingIndex]
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
            // TODO: load city data into map & lazy load journals
            
        } else { // create new city map
            // TODO: create new city map and upload to db
        }
        
    }
    
}
