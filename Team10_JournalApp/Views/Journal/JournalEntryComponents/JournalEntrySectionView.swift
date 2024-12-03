//
//  JournalEntrySectionView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 12/2/24.
//

import SwiftUI

struct JournalEntrySection: View {
    let title: String
    @Binding var text: String
    let isEditable: Bool

    @FocusState private var focusedField: Bool // Tracks focus state of the text field

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text(title)
                .font(
                    Font.custom("Qanelas Soft DEMO", size: 20)
                        .weight(.medium)
                )
                .foregroundColor(Constants.LabelsPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 5)
            
            // TextField with dynamic placeholder and top-left alignment
            TextField(isEditable ? "Type your response here..." : "This entry is empty.", text: $text, axis: .vertical)
                .autocapitalization(.none)
                .lineLimit(nil) // Allow multiline input
                .frame(maxWidth: .infinity, minHeight: 111, maxHeight: 111, alignment: .topLeading)
                .background(
                    Color(red: 0.87, green: 0.95, blue: 0.99)
                        .cornerRadius(5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                )
                .focused($focusedField)
                .disabled(!isEditable)
        }
    }
}

#Preview {
    JournalEntrySection(
        title: "What are you grateful for?",
        text: .constant(""),
        isEditable: true
    )
}

