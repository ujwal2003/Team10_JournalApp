//
//  FeatureTestingView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import SwiftUI

struct FeatureTestingView: View {
    @ObservedObject var appController: AppViewController
    
    @State private var selectedTestTab: TestingTab = .JournalEntry
    enum TestingTab: String {
        case JournalEntry, CityBlockData, SentimentTest, FriendsTest
    }
    
    var body: some View {
        NavigationStack {
            let loadedUserProfile = appController.loadedUserProfile
            
            VStack {
                switch selectedTestTab {
                    case .JournalEntry:
                        JournalEntryDataTestView(loadedUserProfile: loadedUserProfile)
                    case .CityBlockData:
                        CityBlockDataTestView(loadedUserProfile: loadedUserProfile)
                    case .SentimentTest:
                        SentimentAnalysisTestView()
                    case .FriendsTest:
                        FriendsTestView(loadedUserProfile: loadedUserProfile)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Feature Test", selection: $selectedTestTab) {
                        Text(TestingTab.JournalEntry.rawValue).tag(TestingTab.JournalEntry)
                        Text(TestingTab.CityBlockData.rawValue).tag(TestingTab.CityBlockData)
                        Text(TestingTab.SentimentTest.rawValue).tag(TestingTab.SentimentTest)
                        Text(TestingTab.FriendsTest.rawValue).tag(TestingTab.FriendsTest)
                    }
                    .pickerStyle(.segmented)
                }
            }
            
        }
    }
}
