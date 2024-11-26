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
    
    func calculateOverallSentimentScore(gratitudeScore: Double, thoughtDumpScore: Double, learningScore: Double) -> Double {
        return 0.50 * (gratitudeScore) + 0.35 * (thoughtDumpScore) + 0.15 * (learningScore)
    }
}
