//
//  JournalEntryViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/3/24.
//

import Foundation

@MainActor
class JournalEntryViewModel: ObservableObject {
    @Published var isSaveJournalLoading: Bool = false
    @Published var isShowingSaveFailedAlert: Bool = false
    
    private func tryUpdatingTodaysJournalEntry(userId: String, journalContent: JournalContent) async -> Bool {
        do {
            try await JournalManager.shared.updateJournalEntry(userId: userId, date: Date(), journalContent: journalContent)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func saveJournal(userId: String, gratitudeEntry: String, learningEntry: String, thoughtDump: String) {
        Task {
            self.isSaveJournalLoading = true
            
            let content = JournalContent(
                gratitudeEntry: gratitudeEntry,
                gratitudeSentiment: Sentiment.Neutral.rawValue,
                learningEntry: learningEntry,
                learningSentiment: Sentiment.Neutral.rawValue,
                thoughtEntry: thoughtDump,
                thoughtSentiment: Sentiment.Neutral.rawValue
            )
            
            let succesfullyUpdated = await tryUpdatingTodaysJournalEntry(userId: userId, journalContent: content)
            
            if !succesfullyUpdated {
                print("No existing journal entry found, attempting to create new entry.")
                let newEntry = JournalEntry(userId: userId, dateCreated: Date(), journalContent: content)
                
                do {
                    try await JournalManager.shared.createNewJournalEntry(journalEntry: newEntry)
                    print("New journal entry created.")
                    
                } catch {
                    self.isSaveJournalLoading = false
                    print("[JOURNAL ENTRY ERROR]: \(error.localizedDescription)")
                    
                    self.isShowingSaveFailedAlert.toggle()
                    return
                }
            }
            
            self.isSaveJournalLoading = false
        }
    }
    
}
