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
    @State private var showAlert: Bool = false

    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        return dateFormatter.string(from: Date())
    }

    @FocusState private var focusedField: JournalEntryField?
    enum JournalEntryField {
        case gratitude, learning, thoughts
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
                            focusedField = nil
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
                    VStack(spacing: 40) {
                        
                        journalEntrySection(
                            title: "What are you grateful for?",
                            text: $gratefulEntry,
                            field: .gratitude,
                            isEditable: isEditing
                        )
                        .padding(.top, 20)
                        
                        journalEntrySection(
                            title: "What did you learn today?",
                            text: $learnEntry,
                            field: .learning,
                            isEditable: isEditing
                        )
                        
                        journalEntrySection(
                            title: "Thought dump for the day",
                            text: $thoughtEntry,
                            field: .thoughts,
                            isEditable: isEditing
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
                }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }
    
    // Helper to create a journal entry section
    @ViewBuilder
    private func journalEntrySection(title: String, text: Binding<String>, field: JournalEntryField, isEditable: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(
                    Font.custom("Qanelas Soft DEMO", size: 20)
                        .weight(.medium)
                )
                .foregroundColor(Constants.LabelsPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 5)
            
            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text("This entry is empty.")
                        .foregroundColor(Color.gray.opacity(0.7))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                }
                
                TextEditor(text: text)
                    .autocapitalization(.none)
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, minHeight: 111, maxHeight: 111)
                    .background(
                        Color(red: 0.87, green: 0.95, blue: 0.99)
                            .cornerRadius(5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                    )
                    .focused($focusedField, equals: field)
                    .disabled(!isEditable)
            }
        }
    }
}

#Preview {
    JournalEntryView()
}
