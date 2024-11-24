//
//  FirestoreDataError.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import Foundation

enum FirestoreDataError: Error {
    case journalEntryNotFound(userID: String, date: Date)
}

extension FirestoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .journalEntryNotFound(let userID, let date):
            return "Could not find journal entry for user \(userID) on date \(date)"
        }
    }
}
