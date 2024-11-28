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
    
    func loadMockUserJournalsMap(homeViewModel: HomeViewModel) {
        homeViewModel.currWeek = homeViewModel.getWeekRange(offset: 0)
        homeViewModel.numFriends = 5
        
        homeViewModel.cityHealthPercentage = 1.0
        homeViewModel.currSentimentWeather = .Sunny
        
        let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        homeViewModel.currWeekJournal = Array(
            repeating: .init(
                gratitudeSentiment: .Positive,
                gratitudeEntry: dummyText,
                learningSentiment: .Neutral,
                learningEntry: dummyText,
                thoughtSentiment: .Negative,
                thoughtEntry: dummyText
            ),
            count: 7
        )
        
        homeViewModel.currMap = .Map1
        homeViewModel.currCityBlockBuildings = [
            .init(style: .LightBlueTower, onClick: {
                homeViewModel.selectedBuildingIndex = 0
                homeViewModel.isGrowthReportShowing.toggle()
            }),
            .init(style: .RedRuin, onClick: {
                homeViewModel.selectedBuildingIndex = 1
                homeViewModel.isGrowthReportShowing.toggle()
            }),
            .init(style: .YellowConstruction, onClick: {
                homeViewModel.selectedBuildingIndex = 2
                homeViewModel.isGrowthReportShowing.toggle()
            }),
            .init(style: .Scaffolding, onClick: {
                homeViewModel.selectedBuildingIndex = 3
                homeViewModel.isGrowthReportShowing.toggle()
            }),
            .init(style: .PurpleConstruction, onClick: {
                homeViewModel.selectedBuildingIndex = 4
                homeViewModel.isGrowthReportShowing.toggle()
            }),
            .init(style: .BrownTower, onClick: {
                homeViewModel.selectedBuildingIndex = 5
                homeViewModel.isGrowthReportShowing.toggle()
            }),
            .init(style: .LightGreenTower, onClick: {
                homeViewModel.selectedBuildingIndex = 6
                homeViewModel.isGrowthReportShowing.toggle()
            })
        ]
        
        homeViewModel.recommendedActions = [
            .init(searchQuery: "parks",
                  title: "Park",
                  description: "Going to the park is a great way to improve your physical and mental health."),
            
                .init(searchQuery: "coffee shops",
                      title: "Chill & Chat",
                      description: "Reach out to a friend or loved one for a chat at a coffee shop")
        ]
    }
    
}
