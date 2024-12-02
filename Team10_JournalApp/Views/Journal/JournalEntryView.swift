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
    @State private var showAlert: Bool = false

    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy" // Example: Monday, October 21, 2024
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
                    
                    Text(currentDate)
                        .font(.system(size: 20.0).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                // Main content
                ScrollView {
                    
                    VStack(spacing: 10) {
                        VStack(spacing: 91) {
                            Button(action: {
                                showAlert = true
                            }) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 315, height: 52)
                                        .background(Color(red: 0.09, green: 0.28, blue: 0.39))
                                        .cornerRadius(100)
                                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                    
                                    Text("Edit")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .padding(.top, 22)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Journal Saved"),
                                    message: Text("Your journal entry has been successfully saved."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        
                        journalEntrySection(
                            title: "What are you grateful for?",
                            text: $gratefulEntry,
                            field: .gratitude
                        )
                        
                        journalEntrySection(
                            title: "What did you learn today?",
                            text: $learnEntry,
                            field: .learning
                        )
                        
                        journalEntrySection(
                            title: "Thought dump for the day",
                            text: $thoughtEntry,
                            field: .thoughts
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
    private func journalEntrySection(title: String, text: Binding<String>, field: JournalEntryField) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(
                    Font.custom("Qanelas Soft DEMO", size: 20)
                        .weight(.medium)
                )
                .foregroundColor(Constants.LabelsPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            ZStack(alignment: .topLeading) {
                // Prefill text (placeholder)
                if text.wrappedValue.isEmpty {
                    Text("This entry is empty.")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                }
                
                // TextEditor
                TextEditor(text: text)
                    .autocapitalization(.none)
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, minHeight: 111, maxHeight: 111)
                    .background(
                        Color(red: 0.87, green: 0.95, blue: 0.99) // Light blue background
                            .cornerRadius(5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                    )
                    .focused($focusedField, equals: field)
                    .padding(.horizontal, 5) // Match the padding of placeholder text
            }
        }
    }

}

#Preview {
    JournalEntryView()
}

