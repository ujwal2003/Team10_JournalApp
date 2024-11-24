//
//  JournalEntryModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import Foundation
import FirebaseFirestore

struct JournalEntry: Codable {
    @DocumentID var journalId: String?
    let userId: String
    let dateCreated: Date
    
    let gratitudeEntry: String
    let gratitudeSentiment: String
    
    let learningEntry: String
    let learningSentiment: String
    
    let thoughtEntry: String
    let thoughtSentiment: String
    
    enum CodingKeys: String, CodingKey {
        case journalId = "journal_id"
        case userId = "user_id"
        case dateCreated = "date_created"
        case gratitudeEntry = "gratitude_entry"
        case gratitudeSentiment = "gratitude_sentiment"
        case learningEntry = "learning_entry"
        case learningSentiment = "learning_sentiment"
        case thoughtEntry = "thought_entry"
        case thoughtSentiment = "thought_sentiment"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._journalId = try container.decode(DocumentID<String>.self, forKey: .journalId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.gratitudeEntry = try container.decode(String.self, forKey: .gratitudeEntry)
        self.gratitudeSentiment = try container.decode(String.self, forKey: .gratitudeSentiment)
        self.learningEntry = try container.decode(String.self, forKey: .learningEntry)
        self.learningSentiment = try container.decode(String.self, forKey: .learningSentiment)
        self.thoughtEntry = try container.decode(String.self, forKey: .thoughtEntry)
        self.thoughtSentiment = try container.decode(String.self, forKey: .thoughtSentiment)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.journalId, forKey: .journalId)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.gratitudeEntry, forKey: .gratitudeEntry)
        try container.encode(self.gratitudeSentiment, forKey: .gratitudeSentiment)
        try container.encode(self.learningEntry, forKey: .learningEntry)
        try container.encode(self.learningSentiment, forKey: .learningSentiment)
        try container.encode(self.thoughtEntry, forKey: .thoughtEntry)
        try container.encode(self.thoughtSentiment, forKey: .thoughtSentiment)
    }
}
