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
    
    private func journalEntryDocument(userId: String, date: Date) async throws -> DocumentReference {
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
    
    func getJournalEntry(userId: String, date: Date) async throws -> JournalEntry {
        try await journalEntryDocument(userId: userId, date: date).getDocument(as: JournalEntry.self)
    }
}
