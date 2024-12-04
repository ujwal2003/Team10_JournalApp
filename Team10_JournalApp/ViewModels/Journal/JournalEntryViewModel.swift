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
    
    func saveJournal(userId: String, gratitudeEntry: String, learningEntry: String, thoughtDump: String, onSuccess: @escaping () -> Void) {
        Task {
            self.isSaveJournalLoading = true
            
            let gratitudeSentimentScore = SentimentAnalyzer.shared.analyzeSentiment(text: gratitudeEntry)
            let learningSentimentScore = SentimentAnalyzer.shared.analyzeSentiment(text: learningEntry)
            let thoughtDumpSentimentScore = SentimentAnalyzer.shared.analyzeSentiment(text: thoughtDump)
            
            let gratitudeSentiment = SentimentAnalyzer.shared.getMappedSentimentLabelFromScore(sentimentScore: gratitudeSentimentScore)
            let learningSentiment = SentimentAnalyzer.shared.getMappedSentimentLabelFromScore(sentimentScore: learningSentimentScore)
            let thoughtDumpSentiment = SentimentAnalyzer.shared.getMappedSentimentLabelFromScore(sentimentScore: thoughtDumpSentimentScore)
            
            let content = JournalContent(
                gratitudeEntry: gratitudeEntry,
                gratitudeSentiment: gratitudeSentiment.rawValue,
                learningEntry: learningEntry,
                learningSentiment: learningSentiment.rawValue,
                thoughtEntry: thoughtDump,
                thoughtSentiment: thoughtDumpSentiment.rawValue
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
                
            } else {
                print("Succesfully updated journal")
            }
            
            self.isSaveJournalLoading = false
            onSuccess()
        }
    }
    
    func loadTodayJournal(userId: String, onSuccess: @escaping (_ journalEntry: JournalEntry) -> Void) {
        Task {
            self.isSaveJournalLoading = true
            
            do {
                let fetchedEntry = try await JournalManager.shared.getJournalEntryFromDateQuery(userId: userId, date: Date())
                
                print("fetched journal entry for today")
                
                self.isSaveJournalLoading = false
                onSuccess(fetchedEntry)
                
            } catch {
                self.isSaveJournalLoading = false
                print("no journal entry to fetch")
            }
        }
    }
    
    func saveJournalIDToCityBlock(userId: String, onSuccess: @escaping () -> Void) {
        Task {
            self.isSaveJournalLoading = true
            
            do {
                let todaysEntry = try await JournalManager.shared.getJournalEntryFromDateQuery(userId: userId, date: Date())
                
                if let journalId = todaysEntry.journalId {
                    let currWeek = CommonUtilities.util.getWeekStartEndDates()
                    
                    let todayIndex = Calendar.current.component(.weekday, from: Date()) - 1
                    let day = DayID.getDayIDByInteger(dayIndex: todayIndex) ?? .Sunday
                    
                    try await CityBlockManager.shared.addJournalToCityBlockMap(
                        userId: userId,
                        weekStartDate: currWeek.startDate,
                        weekEndDate: currWeek.endDate,
                        dayID: day,
                        journalId: journalId
                    )
                    
                    print("Succesfully loaded journal id into currentcity block")
                    self.isSaveJournalLoading = false
                    
                    onSuccess()
                }
                
            } catch {
                self.isSaveJournalLoading = false
                print("Failed to update city block data.")
            }
        }
    }
    
}
