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
    @Published var friendCurrWeekJournal: [GrowthReport] = []
    
    @Published var isGrowthReportShowing: Bool = false
    @Published var selectedBuildingIndex: Int = 0
    
    func getBuildingJournalView() -> CityJournalBuildingView {
        let day = "\(dayToIndex[self.selectedBuildingIndex] ?? "Day")"
        let selectedBuilding = self.friendCityBlockBuildings[self.selectedBuildingIndex].style
        
        var growthHeadline: String {
            if selectedBuilding.category == .Ruin {
                return "Ruins of \(day)"
            }
            
            return "\(day) City Growth"
        }
        
        let currWeekJournal = self.friendCurrWeekJournal
        if !currWeekJournal.isEmpty {
            return CityJournalBuildingView(
                headlineTitle: growthHeadline,
                building: selectedBuilding,
                growthReport: currWeekJournal[self.selectedBuildingIndex],
                selectedMenuView: .Journal
            )
        }
        
        return CityJournalBuildingView(
            headlineTitle: growthHeadline,
            building: selectedBuilding,
            growthReport: .init(
                gratitudeSentiment: .Neutral,
                gratitudeEntry: "ERROR",
                learningSentiment: .Neutral,
                learningEntry: "ERROR",
                thoughtSentiment: .Neutral,
                thoughtEntry: "ERROR"),
            selectedMenuView: .Journal
        )
    }
    
}
