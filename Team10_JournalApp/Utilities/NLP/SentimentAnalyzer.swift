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
    
    /// The Sentiment computEd Analyzed Number (SEAN) equation
    func calculateOverallSentimentScore(gratitudeScore: Double, thoughtDumpScore: Double, learningScore: Double) -> Double {
        return 0.50 * (gratitudeScore) + 0.35 * (thoughtDumpScore) + 0.15 * (learningScore)
    }
    
    func getMappedSentimentLabelFromScore(sentimentScore: Double) -> Sentiment {
        switch sentimentScore {
            case 0.625 ... 1.0: return .Positive
            case 0.25 ..< 0.625: return .Fair
            case -0.25 ..< 0.25: return .Neutral
            case -0.625 ..< -0.25: return .Concerning
            case -1.0 ..< -0.625: return .Negative
            
            default: return .Error
        }
    }
}
