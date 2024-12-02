//
//  CityJournalBuildingViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/1/24.
//

import Foundation
import SwiftUI

@MainActor
final class CityJournalBuildingViewModel: ObservableObject {
    func getViewTitle(date: Date, building: Building) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: date)
        
        if building.category == .Ruin {
            return "Ruins of \(day)"
        }
        
        return "\(day) City Growth"
    }
    
    func getConstructionOrRuinIndicatorsView(building: Building) -> some View {
        let indicatorIcon = (building.category == .Construction) ? "hugeicons_question" : "subway_error"
        let iconSize: CGFloat = (building.category == .Construction) ? 300 : 245
        
        var indicatorText: String {
            if building.category == .Ruin {
                return "Not available. These buildings lay in ruins because no journal entries were made on this day."
            }
            
            return "The journal entries have yet to be made, these buildings are still under construction."
        }
        
        return VStack {
            Image(indicatorIcon)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize)
                .padding()
            
            Text(indicatorText)
                .font(.system(size: 22))
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    func getScaffoldingIndicatorsView() -> some View {
        return VStack {
            HStack {
                Spacer()
                Image(systemName: "book.and.wrench")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(Color.hex("#5B5C69").opacity(0.70))
                Spacer()
            }
            
            Text("This building is set to be constructed at a future date.")
                .font(.system(size: 22))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
        }
    }
    
    func getErroredEntry() -> JournalEntry {
        return .init(
            userId: "",
            dateCreated: Date(),
            gratitudeEntry: "Failed to fetch journal entry.",
            gratitudeSentiment: Sentiment.Error.rawValue,
            learningEntry: "Failed to fetch journal entry.",
            learningSentiment: Sentiment.Error.rawValue,
            thoughtEntry: "Failed to fetch journal entry.",
            thoughtSentiment: Sentiment.Error.rawValue
        )
    }
    
}
