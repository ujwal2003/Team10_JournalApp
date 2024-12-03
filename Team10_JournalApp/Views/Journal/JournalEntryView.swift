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

    // Current date formatted as a readable string
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        return dateFormatter.string(from: Date())
    }

    var body: some View {
        NavigationStack {
            // Header section with title and date
            AppLayoutContainer(height: 20.0) {
                VStack(alignment: .leading, spacing: 10) {
                    // Page title
                    Text("Journal Entry")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                    
                    // Current date and edit button
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
                // Main content: Journal entry sections
                ScrollView {
                    VStack(spacing: 30) {
                        // Section for gratitude entry
                        JournalEntrySection(
                            title: "What are you grateful for?",
                            text: $gratefulEntry,
                            isEditable: isEditing
                        )
                        .padding(.top, 20)
                        
                        // Section for learning entry
                        JournalEntrySection(
                            title: "What did you learn today?",
                            text: $learnEntry,
                            isEditable: isEditing
                        )
                        
                        // Section for thought entry
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
    AppTabMockContainerView(previewTab: .Journal) {
        JournalEntryView()
    }
}
