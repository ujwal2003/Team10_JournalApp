//
//  JournalWeather.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/30/24.
//

import Foundation
import SwiftUI

enum JournalWeather {
    case Sunny
    case Cloudy
    case Drizzle
    case Rain
    case Stormy
    case NoData
    case Error
}

enum Sentiment {
    case Positive
    case Neutral
    case Negative
    
    var textView: Text {
        switch self {
            case .Positive:
                return Text("Positive")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#5EB881"))
            
            case .Neutral:
                return Text("Neutral")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#8A8A8A"))
            
            case .Negative:
                return Text("Negative")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#DE5353"))
        }
    }
    
    var report: String {
        switch self {
            case .Positive:
                return "You have infused the city with positivity, causing this building to shine brightly. Citizens feel more connected and at peace. This uplifting energy has led to increased city growth and well-being."
            
            case .Neutral:
                return "This reflects a balanced mindset today, neither overly joyful nor overly troubled. Progress is steady, and the city remains stable."
                
            case .Negative:
                return "Negative feelings have weighed down this building, causing its lights to dim. The city is struggling to maintain its usual vibrancy, and citizens feel a bit disconnected. Consider journaling tomorrow to rebuild your city’s strength."
        }
    }
}

struct GrowthReport {
    var gratitudeSentiment: Sentiment
    var gratitudeEntry: String
    
    var learningSentiment: Sentiment
    var learningEntry: String
    
    var thoughtSentiment: Sentiment
    var thoughtEntry: String
}

struct CityMap {
    var map: Map
    var buildings: [BuildingConfig]
    var reports: [GrowthReport]
}