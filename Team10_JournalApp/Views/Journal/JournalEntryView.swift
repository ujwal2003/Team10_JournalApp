//
//  JournalEntryView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/21/24.
//
import SwiftUI
import Foundation

struct JournalEntryView: View {
    @State private var gratefulEntry: String = ""
    @State private var learnEntry: String = ""
    @State private var thoughtEntry: String = ""
    @State private var isEditing: Bool = false

    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        return dateFormatter.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            AppLayoutContainer(height: 20.0) {
                // Title content
                VStack(alignment: .leading, spacing: 10) {
                    Text("Journal Entry")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                    
                    HStack {
                        Text(currentDate)
                            .font(.system(size: 18.0).weight(.medium))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 40.0)
                            .foregroundStyle(Color.black)
                        
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text(isEditing ? "Done" : "Edit")
                                .font(.system(size: 18.0))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.trailing, 40.0)
                        }
                    }
                }
                .padding(.vertical)
            } containerContent: {
                // Main content
                ScrollView {
                    VStack(spacing: 30) {
                        JournalEntrySection(
                            title: "What are you grateful for?",
                            text: $gratefulEntry,
                            isEditable: isEditing
                        )
                        .padding(.top, 20)
                        
                        JournalEntrySection(
                            title: "What did you learn today?",
                            text: $learnEntry,
                            isEditable: isEditing
                        )
                        
                        JournalEntrySection(
                            title: "Thought dump for the day",
                            text: $thoughtEntry,
                            isEditable: isEditing
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
                }
            }
        }
    }
}

#Preview {
    JournalEntryView()
}
