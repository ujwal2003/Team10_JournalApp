//
//  JournalManager.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import Foundation
import FirebaseFirestore

final class JournalManager {
    static let shared = JournalManager()
    private init() { }
    
    private let journalCollection = Firestore.firestore().collection("journals")
    
    func createNewJournalEntry(journalEntry: JournalEntry) async throws {
        try journalCollection.addDocument(from: journalEntry)
    }
    
    private func journalEntryDocument(journalId: String) async throws -> DocumentReference {
        journalCollection.document(journalId)
    }
    
    private func journalEntryQueriedDocument(userId: String, date: Date) async throws -> DocumentReference {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let query = journalCollection
            .whereField("user_id", isEqualTo: userId)
            .whereField("date_created", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date_created", isLessThan: endOfDay)
            .limit(to: 1)
        
        let querySnapshot = try await query.getDocuments()
        guard let document = querySnapshot.documents.first else {
            throw FirestoreDataError.journalEntryNotFound(userID: userId, date: date)
        }
        
        return document.reference
    }
    
    func getJournalEntryFromId(journalId: String) async throws -> JournalEntry {
        try await journalEntryDocument(journalId: journalId).getDocument(as: JournalEntry.self)
    }
    
    func getJournalEntryFromDateQuery(userId: String, date: Date) async throws -> JournalEntry {
        try await journalEntryQueriedDocument(userId: userId, date: date).getDocument(as: JournalEntry.self)
    }
    
    func updateJournalEntry(userId: String, date: Date, journalContent: JournalContent) async throws {
        let data: [String: Any] = [
            JournalEntry.CodingKeys.gratitudeEntry.rawValue : journalContent.gratitudeEntry,
            JournalEntry.CodingKeys.gratitudeSentiment.rawValue : journalContent.gratitudeSentiment,
            JournalEntry.CodingKeys.learningEntry.rawValue : journalContent.learningEntry,
            JournalEntry.CodingKeys.learningSentiment.rawValue : journalContent.learningSentiment,
            JournalEntry.CodingKeys.thoughtEntry.rawValue : journalContent.thoughtEntry,
            JournalEntry.CodingKeys.thoughtSentiment.rawValue : journalContent.thoughtSentiment
        ]
        
        try await journalEntryQueriedDocument(userId: userId, date: date).updateData(data)
    }
    
    func getAllUserJournalEntriesQuery(userId: String) -> Query {
        let query = journalCollection.whereField("user_id", isEqualTo: userId)
        return query
    }
    
    func bulkDeleteAllUserJournalEntries(userId: String) async throws {
        let querySnapshot = try await getAllUserJournalEntriesQuery(userId: userId).getDocuments()
        
        let batch = Firestore.firestore().batch()
        
        for document in querySnapshot.documents {
            batch.deleteDocument(document.reference)
        }
        
        try await batch.commit()
        print("[DB]: Succesfully deleted all journal entries for user \(userId)")
    }
}
