//
//  CityGrowthView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/19/24.
//

import SwiftUI

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
    @State var growthReport: GrowthReport
    
    @Environment(\.dismiss) var dismiss
    
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
                    
                    Text(headlineTitle)
                        .font(.system(size: 30))
                        .fontWeight(.heavy)
                        .padding()
                    
                    GrowthReportView(geometry: geometry,
                                     title: "Gratitude Building",
                                     text: growthReport.gratitudeReport,
                                     sentiment: growthReport.gratitudeSentiment)
                    
                    GrowthReportView(geometry: geometry,
                                     title: "Learning Building",
                                     text: growthReport.learningReport,
                                     sentiment: growthReport.learningSentiment)
                    .padding(.top)
                    
                    GrowthReportView(geometry: geometry,
                                     title: "Thought Building",
                                     text: growthReport.thoughtReport,
                                     sentiment: growthReport.thoughtSentiment)
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var preivewText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    
    CityGrowthView(headlineTitle: "Today's City Growth",
                   growthReport: GrowthReport(gratitudeSentiment: .Positive,
                                              gratitudeReport: preivewText,
                                              learningSentiment: .Neutral,
                                              learningReport: preivewText,
                                              thoughtSentiment: .Negative,
                                              thoughtReport: preivewText))
}
