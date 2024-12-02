//
//  CityBlockManager.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/25/24.
//

import Foundation
import FirebaseFirestore

final class CityBlockManager {
    static let shared = CityBlockManager()
    private init() { }
    
    private let cityCollection = Firestore.firestore().collection("cities")
    
    func createNewCityBlockMap(cityBlockData: CityBlockData) async throws {
        try cityCollection.addDocument(from: cityBlockData)
    }
    
    private func cityBlockMapDocument(userId: String, weekStartDate: Date, weekEndDate: Date) async throws -> DocumentReference {
        let calendar = Calendar.current
        let normalizedWeekStartDate = calendar.startOfDay(for: weekStartDate)
        let normalizedWeekEndDate = calendar.startOfDay(for: weekEndDate)
        
        let queryWeekEndRangeDate = calendar.date(byAdding: .day, value: 1, to: normalizedWeekEndDate)!
        
        let query = cityCollection
            .whereField("user_id", isEqualTo: userId)
            .whereField("week_start_date", isGreaterThanOrEqualTo: normalizedWeekStartDate)
            .whereField("week_end_date", isLessThan: queryWeekEndRangeDate)
            .limit(to: 1)
        
        let querySnapshot = try await query.getDocuments()
        guard let document = querySnapshot.documents.first else {
            throw FirestoreDataError.cityBlockMapNotFound(userID: userId, startDate: weekStartDate, endDate: weekEndDate)
        }
        
        return document.reference
    }
    
    func getCityBlockData(userId: String, weekStartDate: Date, weekEndDate: Date) async throws -> CityBlockData {
        try await cityBlockMapDocument(userId: userId, weekStartDate: weekStartDate, weekEndDate: weekEndDate).getDocument(as: CityBlockData.self)
    }
    
    func addJournalToCityBlockMap(userId: String, weekStartDate: Date, weekEndDate: Date, dayID: DayID, journalId: String) async throws {
        let fieldPath = "\(CityBlockData.CodingKeys.journalIDs.rawValue).\(dayID.rawValue)"
        
        let data: [String: Any] = [
            fieldPath: journalId
        ]
        
        try await cityBlockMapDocument(userId: userId, weekStartDate: weekStartDate, weekEndDate: weekEndDate).updateData(data)
    }
}
