//
//  GrowthReportView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/18/24.
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

#Preview {
    GeometryReader { geometry in
        GrowthReportView(
            geometry: geometry,
            title: "Title",
            text: "Lorem ipsum dolor.",
            sentiment: .Neutral
        )
        .padding(.vertical)
    }
}
