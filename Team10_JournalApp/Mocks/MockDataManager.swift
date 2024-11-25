//
//  MockData.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import Foundation

@MainActor
class MockDataManager {
    static let shared = MockDataManager()
    private init() { }
    
    func loadMockUserProfile(appController: AppViewController) {
        appController.loadedUserProfile = UserProfile(
            userId: UUID().uuidString,
            email: "mockData@mockEmail.com",
            displayName: "mockData@mockEmail.com",
            dateCreated: Date(),
            photoURL: nil,
            friendUserIDs: []
        )
    }
}
