//
//  CityGrowthView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/19/24.
//

import SwiftUI

enum ViewSelection {
    case Sentiment
    case Journal
}

struct GrowthReportView: View {
    var geometry: GeometryProxy
    
    var title: String
    var text: String
    var sentiment: Sentiment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.medium)
                .padding(.horizontal)
            
            HStack {
                Text("Sentiment:")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                
                sentiment.textView
            }
            .padding(.horizontal)
            
            ScrollView {
                Text(text)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: geometry.size.height * 0.21)
            .background(Color.hex("#DDF2FD"))
            .clipShape(RoundedCorner(radius: 5))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                .inset(by: 0.5)
                .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.8), lineWidth: 1)
            )
            .padding()
        }
    }
}

struct CityGrowthView: View {
    @State var headlineTitle: String
    @State var buildingType: BuildingCategory
    @State var growthReport: GrowthReport
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedMenuView: ViewSelection = .Sentiment
    
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
                        Text("Sentiment").tag(ViewSelection.Sentiment)
                        Text("Journal").tag(ViewSelection.Journal)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    let isJournalMode: Bool = selectedMenuView == .Journal
                    
                    if buildingType != .Building {
                        let indicatorIcon = (buildingType == .Construction) ? "hugeicons_question" : "subway_error"
                        let iconSize: CGFloat = (buildingType == .Construction) ? 300 : 245
                        
                        var indicatorText: String {
                            if buildingType == .Ruin {
                                return "Not available\nbecause you skipped\nthis journal entry"
                            } else {
                                return isJournalMode ? "Your journal is\nempty" : "Write your journal\nfor today to see the\nsentiment report"
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

#Preview {
    @Previewable @State var preivewText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    
    CityGrowthView(headlineTitle: "Today's City Growth",
                   buildingType: .Building,
                   growthReport: GrowthReport(gratitudeSentiment: .Positive,
                                              gratitudeEntry: preivewText,
                                              learningSentiment: .Neutral,
                                              learningEntry: preivewText,
                                              thoughtSentiment: .Negative,
                                              thoughtEntry: preivewText))
}
