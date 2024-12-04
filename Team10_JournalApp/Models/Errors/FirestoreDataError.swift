//
//  FirestoreDataError.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import Foundation

enum FirestoreDataError: Error {
    case journalEntryNotFound(userID: String, date: Date)
    case cityBlockMapNotFound(userID: String, startDate: Date, endDate: Date)
    case userFriendNotFound(userID: String, friendID: String)
    case emailNotFound(email: String)
}

extension FirestoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .journalEntryNotFound(let userID, let date):
                return "Could not find journal entry for user \(userID) on date \(date)"
                
            case .cityBlockMapNotFound(let userID, let startDate, let endDate):
                return "Could not find map data for user \(userID) in the week of: \(startDate) - \(endDate)"
            
            case .userFriendNotFound(let userID, let friendID):
                return "Could not find friend \(friendID) for user \(userID)"
            
            case .emailNotFound(let email):
                return "Could not find user for the email \(email)"
        }
    }
}
