//
//  AuthenticationErrors.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/19/24.
//

import Foundation

enum AuthenticationError: Error {
    case authenticatedUserNotFound
}

extension AuthenticationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authenticatedUserNotFound:
            return "Attempt to find already authenticated user failed. Try re-authenticating."
        }
    }
}
