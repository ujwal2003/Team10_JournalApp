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
    
    func getAllUserCityBlockDataQuery(userId: String) -> Query {
        let query = cityCollection.whereField("user_id", isEqualTo: userId)
        return query
    }
    
    func getCountOfCitiesForDateRange(userId: String, searchStartDate: Date, searchEndDate: Date) async throws -> Int {
        let aggregateQuery = cityCollection
            .whereField("user_id", isEqualTo: userId)
            .whereField("week_start_date", isGreaterThanOrEqualTo: searchStartDate)
            .whereField("week_end_date", isLessThanOrEqualTo: searchEndDate)
            .count
        
        let querySnapshot = try await aggregateQuery.getAggregation(source: .server)
        return querySnapshot.count.intValue
    }
    
    func getCountOfSkippedEntriesFromCitiesOnDateRange(userId: String, searchStartDate: Date, searchEndDate: Date) async throws -> Int {
        let query = cityCollection
            .whereField("user_id", isEqualTo: userId)
            .whereField("week_start_date", isGreaterThanOrEqualTo: searchStartDate)
            .whereField("week_end_date", isLessThanOrEqualTo: searchEndDate)
        
        let querySnapshot = try await query.getDocuments()
        
        var totalSkippedJournalsCount = 0
        for document in querySnapshot.documents {
            let data = try document.data(as: CityBlockData.self)
            
            let skippedJournalsCount = CommonUtilities.util.countEmptyStringsInStruct(in: data.journalIDs)
            totalSkippedJournalsCount += skippedJournalsCount
        }
        
        return totalSkippedJournalsCount
    }
    
    func getEarliestStartDate(userId: String) async throws -> Date {
        let query = cityCollection
            .whereField("user_id", isEqualTo: userId)
            .order(by: "week_start_date")
            .limit(to: 1)
        
        let querySnapshot = try await query.getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            throw FirestoreDataError.earliestStartDateNotFound(userID: userId)
        }
        
        let data = try document.data(as: CityBlockData.self)
        return data.weekStartDate
    }
    
    func bulkDeleteAllUserCityBlockData(userId: String) async throws {
        let querySnapshot = try await getAllUserCityBlockDataQuery(userId: userId).getDocuments()
        
        let batch = Firestore.firestore().batch()
        
        for document in querySnapshot.documents {
            batch.deleteDocument(document.reference)
        }
        
        try await batch.commit()
        print("[DB]: Succesfully deleted all city block data for user \(userId)")
    }
}
