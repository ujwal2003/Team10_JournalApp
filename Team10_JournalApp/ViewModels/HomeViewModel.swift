//
//  HomeViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/18/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var currWeek: String = "XX/XX/XX - XX/XX/XX"
    
    @Published var cityHealthPercentage: CGFloat = 0.0
    @Published var currSentimentWeather: JournalWeather = .NoData
    
    @Published var currMap: Map = .LoadingMap
    @Published var currCityBlockBuildings: [BuildingConfig] = []
    
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
    
}
