//
//  SentimentAnalyzer.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/26/24.
//

import Foundation
import CoreML
import NaturalLanguage

final class SentimentAnalyzer {
    static let shared = SentimentAnalyzer()
    private init() { }
    
    func analyzeSentiment(text: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentimentScore, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        return Double(sentimentScore?.rawValue ?? "0") ?? 0
    }
}
