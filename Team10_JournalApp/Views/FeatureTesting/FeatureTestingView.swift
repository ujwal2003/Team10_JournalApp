//
//  FeatureTestingView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import SwiftUI

struct TestButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var textColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .shadow(radius: 5)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct FeatureTestingView: View {
    @ObservedObject var appController: AppViewController
    
    var body: some View {
        let loadedUserProfile = appController.loadedUserProfile
        
        VStack {
            Group {
                if let userProfile = loadedUserProfile {
                    Text("User: \(userProfile.displayName)")
                } else {
                    Text("Loading user...")
                }
            }
            
            // MARK: - Make new journal entry
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            let newEntry = JournalEntry(
                                userId: userProfile.userId,
                                dateCreated: Date(),
                                gratitudeEntry: "Lorem ipsum dolor",
                                gratitudeSentiment: "positive",
                                learningEntry: "Lorem ipsum dolor",
                                learningSentiment: "neutral",
                                thoughtEntry: "Lorem ipsum dolor",
                                thoughtSentiment: "negative"
                            )
                            
                            try await JournalManager.shared.createNewJournalEntry(journalEntry: newEntry)
                            print("Succesfully created journal for today")
                        }
                    } catch {
                        print("Failed to make new journal entry with error: \(error)")
                    }
                }
            } label: {
                Text("Create New Journal Entry for user").font(.headline)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.blue, textColor: Color.white))
            
            // MARK: - Update today's journal entry
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            let newContent = JournalContent(
                                gratitudeEntry: "Gratitude entry updated at \(Date())",
                                gratitudeSentiment: "Neutral",
                                learningEntry: "Learning entry updated at \(Date())",
                                learningSentiment: "Negative",
                                thoughtEntry: "Thought dump updated at \(Date())",
                                thoughtSentiment: "Positive"
                            )
                            
                            try await JournalManager.shared.updateJournalEntry(userId: userProfile.userId, date: Date(), journalContent: newContent)
                            print("Succesfully updated journal for today")
                        }
                    } catch {
                        print("Failed to update today's journal entry with error: \(error)")
                    }
                }
            } label: {
                Text("Update today's journal entry for user").font(.headline)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.cyan, textColor: Color.white))
            
            
        }
    }
}
