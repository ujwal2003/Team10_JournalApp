//
//  CommonUtilities.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/28/24.
//

import Foundation
import SwiftUI
import CoreLocation

final class CommonUtilities {
    static let util = CommonUtilities()
    private init() { }
    
    let isIphone16ProMaxPortrait: Bool = UIScreen.main.bounds.height == 956.0
    
    func getSavedUserUseLocationSettingKey(userId: String) -> String {
        return "CatchUp_useCurrLocation_\(userId)"
    }
    
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
    
    /// Returns Date object offset from the current Date.
    /// Offset of 0 is today's date, negative numbers are dates before today and positive numbers are dates after today.
    func getDateByOffset(offset: Int) -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        let newDate = calendar.date(byAdding: .day, value: offset, to: currentDate)!
        return newDate
    }
    
    /// Returns a tuple of two Date objects with the first being the starting date of the week and the second being the ending date.
    /// Default offset of 0 represent the current week, negative numbers will return previous weeks and positive will return future weeks.
    func getWeekStartEndDates(offset: Int = 0) -> (startDate: Date, endDate: Date) {
        let currentDate = Date()
        
        let calendar = Calendar.current
        
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        
        let targetWeekStart = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfWeek)!
        let targetWeekEnd = calendar.date(byAdding: .day, value: 6, to: targetWeekStart)!
        
        return (startDate: targetWeekStart, endDate: targetWeekEnd)
    }
    
    /// Returns Date of the day of the week for the specified week
    /// (Specified by providing the starting date [Sunday] of the week).
    func getWeekDates(startDateOfWeek: Date, dayOfWeek: DayID) -> Date {
        let calendar = Calendar.current
        
        let resultDate = calendar.date(byAdding: .day, value: dayOfWeek.dayInteger, to: startDateOfWeek)!
        return resultDate
    }
    
    func getJournalIdByDayIdKey(weekJournals: JournalDaysIDs, day: DayID) -> String {
        switch day {
            case .Sunday:
                return weekJournals.sundayID
            case .Monday:
                return weekJournals.mondayID
            case .Tuesday:
                return weekJournals.tuesdayID
            case .Wednesday:
                return weekJournals.wednesdayID
            case .Thursday:
                return weekJournals.thursdayID
            case .Friday:
                return weekJournals.fridayID
            case .Saturday:
                return weekJournals.saturdayID
        }
    }
    
    func decodePlaceFromCoordinates(latitude: Double, longitude: Double) async throws -> CLPlacemark? {
        let placemarks = try await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude))
        
        guard let place = placemarks.first else {
            return nil
        }
        
        return place
    }
    
}
