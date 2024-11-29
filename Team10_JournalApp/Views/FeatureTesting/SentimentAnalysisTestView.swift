//
//  SentimentAnalysisTestView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/26/24.
//

import SwiftUI

struct TestTextFiledView: View {
    var placeholder: String
    @Binding var inputText: String
    
    var body: some View {
        TextField(placeholder, text: $inputText)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
            )
    }
}

struct SentimentAnalysisTestView: View {
    @State var gratitudeEntry = ""
    @State var learningEntry = ""
    @State var thoughtEntry = ""
    
    @State var gratitudeScore: Double?
    @State var learningScore: Double?
    @State var thoughtScore: Double?
    
    var body: some View {
        VStack {
            Group {
                TestTextFiledView(placeholder: "Gratitude...", inputText: $gratitudeEntry)
                TestTextFiledView(placeholder: "Learning...", inputText: $learningEntry)
                TestTextFiledView(placeholder: "Thought Dump...", inputText: $thoughtEntry)
            }
            .padding([.leading, .trailing])
            
            Button {
                let sentimentAnalyzer = SentimentAnalyzer.shared.analyzeSentiment
                
                gratitudeScore = sentimentAnalyzer(gratitudeEntry)
                learningScore = sentimentAnalyzer(learningEntry)
                thoughtScore = sentimentAnalyzer(thoughtEntry)
            } label: {
                Text("Analyze Sentiment").font(.headline)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.blue, textColor: Color.white))
            .padding()
            
            let getLabel = SentimentAnalyzer.shared.getMappedSentimentLabelFromScore
            
            Text("Gratitude: \(gratitudeScore ?? -5.0), \(getLabel(gratitudeScore ?? -5.0))")
            Text("Learning: \(learningScore ?? -5.0), \(getLabel(learningScore ?? -5.0))")
            Text("Thought: \(thoughtScore ?? -5.0), \(getLabel(thoughtScore ?? -5.0))")
            
            let overallScore = SentimentAnalyzer.shared.calculateOverallSentimentScore(
                gratitudeScore: gratitudeScore ?? -5.0,
                thoughtDumpScore: thoughtScore ?? -5.0,
                learningScore: learningScore ?? -5.0
            )
            
            Text("Overall Score: \(overallScore), \(getLabel(overallScore).mappedWeather)")
            
        }
    }
}

#Preview {
    SentimentAnalysisTestView()
}
