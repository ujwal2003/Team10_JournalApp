//
//  CityJournalBuildingView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/18/24.
//

import SwiftUI

@available(*, deprecated, message: "Use CityJournalBuildingView instead")
struct CityJournalBuildingView: View {
    @State var headlineTitle: String
    
    @State var building: Building
    @State var growthReport: GrowthReport
    
    @Environment(\.dismiss) var dismiss
    @State var selectedMenuView: CityBuildingViewSelection
    
    init(headlineTitle: String,
         building: Building,
         growthReport: GrowthReport,
         selectedMenuView: CityBuildingViewSelection = .Sentiment) {
        
        self.headlineTitle = headlineTitle
        self.building = building
        self.growthReport = growthReport
        self.selectedMenuView = selectedMenuView
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    
                    HStack {
                        Spacer()
                        Button("Done") {
                            dismiss()
                        }
                        .fontWeight(.medium)
                        .padding([.top, .leading, .trailing])
                    }
                    .padding(.trailing)
                    
                    Text(headlineTitle)
                        .font(.system(size: 30))
                        .fontWeight(.heavy)
                        .padding()
                    
                    Picker("Selection", selection: $selectedMenuView) {
                        Text("Sentiment").tag(CityBuildingViewSelection.Sentiment)
                        Text("Journal").tag(CityBuildingViewSelection.Journal)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    let isJournalMode: Bool = selectedMenuView == .Journal
                    
                    if building.category != .Building && building != .Scaffolding {
                        let indicatorIcon = (building.category == .Construction) ? "hugeicons_question" : "subway_error"
                        let iconSize: CGFloat = (building.category == .Construction) ? 300 : 245
                        
                        var indicatorText: String {
                            if building.category == .Ruin {
                                return "Not available. These buildings lay in ruins because no journal entries were made on this day."
                            }
                            
                            return "The journal entries have yet to be made, these buildings are still under construction."
                        }
                        
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
                        
                    } else if building == .Scaffolding {
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
                        
                    } else {
                        let gratitudeText = isJournalMode ? growthReport.gratitudeEntry : growthReport.gratitudeSentiment.report
                        let learningText = isJournalMode ? growthReport.learningEntry : growthReport.learningSentiment.report
                        let thoughtText = isJournalMode ? growthReport.thoughtEntry : growthReport.thoughtSentiment.report
                        
                        GrowthReportView(
                            geometry: geometry,
                            title: "Gratitude Building",
                            text: gratitudeText,
                            sentiment: growthReport.gratitudeSentiment
                        )
                        
                        GrowthReportView(
                            geometry: geometry,
                            title: "Learning Building",
                            text: learningText,
                            sentiment: growthReport.learningSentiment
                        )
                        
                        GrowthReportView(
                            geometry: geometry,
                            title: "Thought Building",
                            text: thoughtText,
                            sentiment: growthReport.thoughtSentiment
                        )
                        
                    }
                    
                }
            }
        }
        
    }
}

//#Preview {
//    CityJournalBuildingView(
//        headlineTitle: "Ruins of Monday",
//        building: .RedTower,
//        growthReport: .init(
//            gratitudeSentiment: .Positive,
//            gratitudeEntry: "Lorem ipsum dolor",
//            learningSentiment: .Neutral,
//            learningEntry: "Lorem ipsum dolor",
//            thoughtSentiment: .Negative,
//            thoughtEntry: "Lorem ipsum dolor"
//        )
//    )
//}
