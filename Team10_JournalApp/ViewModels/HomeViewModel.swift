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
    
    let currentDate = Date()
    
    /// Returns the start and end date of the week in format: "mm/dd/yy - mm/dd/yy"
    /// (offset of 0 is current week, negative numbers are previous week from the current and positive numbers are future weeks from current)
    func getWeekRange(offset: Int) -> String {
        let calendar = Calendar.current
        
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        
        let targetWeekStart = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfWeek)!
        let targetWeekEnd = calendar.date(byAdding: .day, value: 6, to: targetWeekStart)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        
        let startDateString = formatter.string(from: targetWeekStart)
        let endDateString = formatter.string(from: targetWeekEnd)
        
        return "\(startDateString) - \(endDateString)"
    }
    
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
    
}
