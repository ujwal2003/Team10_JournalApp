//
//  CommonUtilities.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/28/24.
//

import Foundation

final class CommonUtilities {
    static let util = CommonUtilities()
    private init() { }
    
    /// Returns the start and end date of the week in format: "mm/dd/yy - mm/dd/yy"
    /// (offset of 0 is current week, negative numbers are previous week from the current and positive numbers are future weeks from current)
    func getWeekRange(offset: Int) -> String {
        let currentDate = Date()
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
