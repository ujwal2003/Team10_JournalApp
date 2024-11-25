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
    
    @State var dateOffset: Int = 0
    @State var displayJournalEntry: JournalEntry?
    @State var entryText: String = "No journal entry loaded..."
    
    func getDateWithOffset(offset: Int) -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        let newDate = calendar.date(byAdding: .day, value: offset, to: currentDate)!
        return newDate
    }
    
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
            
            // MARK: - Get journal by date
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            let searchDate = getDateWithOffset(offset: dateOffset)
                            
                            print("fetching for date: \(searchDate)")
                            let fetchedEntry = try await JournalManager.shared.getJournalEntry(userId: userProfile.userId, date: searchDate)
                            
                            DispatchQueue.main.async {
                                self.displayJournalEntry = fetchedEntry
                            }
                        }
                    } catch {
                        print("Failed to find journal entry for date offset \(dateOffset)")
                        DispatchQueue.main.async {
                            self.entryText = "Error: Not Found"
                        }
                    }
                }
            } label: {
                Text("Get entry for date (offset): \(dateOffset)").font(.headline)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.mint, textColor: Color.white))

            HStack {
                Button {
                    self.dateOffset += 1
                    self.entryText = "No journal entry loaded..."
                    self.displayJournalEntry = nil
                    
                    print("search date set to: \(getDateWithOffset(offset: dateOffset))")
                } label: {
                    Text("+").font(.headline)
                }
                .buttonStyle(TestButtonStyle(backgroundColor: Color.green, textColor: Color.white))
                
                Text("Date Offset: \(dateOffset)")
                    .padding()
                
                Button {
                    self.dateOffset -= 1
                    self.entryText = "No journal entry loaded..."
                    self.displayJournalEntry = nil
                    
                    print("search date set to: \(getDateWithOffset(offset: dateOffset))")
                } label: {
                    Text("-").font(.headline)
                }
                .buttonStyle(TestButtonStyle(backgroundColor: Color.red, textColor: Color.white))
            }
            
            if let entry = displayJournalEntry {
                Group {
                    Text("user: \(entry.userId)")
                    Text("date: \(entry.dateCreated)")
                    
                    Text("gratitude entry: \(entry.gratitudeEntry)")
                    Text("gratitude sentiment: \(entry.gratitudeSentiment)")
                    
                    Text("learning entry: \(entry.learningEntry)")
                    Text("learning sentiment: \(entry.learningSentiment)")
                    
                    Text("thought dump: \(entry.thoughtEntry)")
                    Text("thought sentiment: \(entry.thoughtSentiment)")
                }
                .padding([.leading, .trailing])
                
            } else {
                Text(entryText)
            }
            
        }
    }
}
