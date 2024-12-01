//
//  Sentiment.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/26/24.
//

import SwiftUI

enum Sentiment {
    case Positive
    case Fair
    case Neutral
    case Concerning
    case Negative
    case Error
    case Loading
    
    var textView: Text {
        switch self {
            case .Positive:
                return Text("Positive")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#5EB881"))
            
            case .Fair:
                return Text("Fair")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.hex("#B7FBCF"))
            
            case .Neutral:
                return Text("Neutral")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#8A8A8A"))
            
            case .Concerning:
                return Text("Concerning")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#F9B9A0"))
            
            case .Negative:
                return Text("Negative")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.hex("#DE5353"))
            
            case .Error:
                return Text("Error")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.black)
            
            case .Loading:
                return Text("Loading")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.black)
        }
    }
    
    var report: String {
        switch self {
            case .Positive:
                return "Infusing the city with positivity causes this building to shine brightly. Citizens feel more connected and at peace. This uplifting energy leads to increased city growth and well-being."
            
            case .Fair:
                return "This building brings a sense of balance and stability to the city, with its slightly positive tones and understated design. Citizens feel grounded and reassured, fostering thoughtful connections and a steady, harmonious pace of growth."
            
            case .Neutral:
                return "This reflects a balanced mindset today, neither overly joyful nor overly troubled. Progress is steady, and the city remains stable."
            
            case .Concerning:
                return "The Concerning Building casts a subdued shadow over the city, its muted, uneven tones creating a sense of unease. Citizens tread carefully around it, prompting reflection and caution as the city pauses to address underlying challenges."
                
            case .Negative:
                return "Negative feelings have weighed down this building, causing its lights to dim. The city is struggling to maintain its usual vibrancy, and citizens feel a bit disconnected. Consider journaling tomorrow to rebuild your city’s strength."
            
            case .Error:
                return "This is an error."
            
            case .Loading:
                return "Loading..."
        }
    }
    
    var mappedWeather: JournalWeather {
        switch self {
            case .Positive:
                return .Sunny
            case .Fair:
                return .Cloudy
            case .Neutral:
                return .Drizzle
            case .Concerning:
                return .Rain
            case .Negative:
                return .Stormy
            case .Error:
                return .Error
            case .Loading:
                return .NoData
        }
    }
}
