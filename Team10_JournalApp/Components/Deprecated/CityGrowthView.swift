//
//  CityGrowthView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/19/24.
//

import SwiftUI

@available(*, deprecated, message: "Use CityJournalBuildingView instead")
struct CityGrowthView: View {
    @State var headlineTitle: String
    @State var buildingType: BuildingCategory
    @State var growthReport: GrowthReport
    
    @State var overrideName: String = ""
    
    @Environment(\.dismiss) var dismiss
    @State var selectedMenuView: CityBuildingViewSelection = .Sentiment
    
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
                    
                    if buildingType != .Building {
                        let indicatorIcon = (buildingType == .Construction) ? "hugeicons_question" : "subway_error"
                        let iconSize: CGFloat = (buildingType == .Construction) ? 300 : 245
                        
                        let nameExists = !overrideName.isEmpty
                        
                        var indicatorText: String {
                            if buildingType == .Ruin {
                                return "Not available\nbecause \(nameExists ? overrideName : "you") skipped\nthis journal entry"
                            } else {
                                return isJournalMode ? "\(nameExists ? overrideName+"'s" : "Your") journal is\nempty" : "\(nameExists ? overrideName+" needs to write their " : "Write your") journal\nfor today to see the\nsentiment report"
                            }
                        }
                        
                        Image(indicatorIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: iconSize)
                            .padding()
                        
                        Text(indicatorText)
                            .font(.system(size: 32))
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                        
                    } else {
                        
                        let gratitudeText = isJournalMode ? growthReport.gratitudeEntry : growthReport.gratitudeSentiment.report
                        let learningText = isJournalMode ? growthReport.learningEntry : growthReport.learningSentiment.report
                        let thoughtText = isJournalMode ? growthReport.thoughtEntry : growthReport.thoughtSentiment.report
                        
                        GrowthReportView(geometry: geometry,
                                         title: "Gratitude Building",
                                         text: gratitudeText,
                                         sentiment: growthReport.gratitudeSentiment)
                        
                        GrowthReportView(geometry: geometry,
                                         title: "Learning Building",
                                         text: learningText,
                                         sentiment: growthReport.learningSentiment)
                        .padding(.top)
                        
                        GrowthReportView(geometry: geometry,
                                         title: "Thought Building",
                                         text: thoughtText,
                                         sentiment: growthReport.thoughtSentiment)
                        .padding(.top)
                    }
                    
                }
            }
        }
    }
}

//#Preview {
//    @Previewable @State var preivewText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
//    
//    CityGrowthView(headlineTitle: "Today's City Growth",
//                   buildingType: .Building,
//                   growthReport: GrowthReport(gratitudeSentiment: .Positive,
//                                              gratitudeEntry: preivewText,
//                                              learningSentiment: .Neutral,
//                                              learningEntry: preivewText,
//                                              thoughtSentiment: .Negative,
//                                              thoughtEntry: preivewText))
//}
