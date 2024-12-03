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
    
    var textFieldHeight: CGFloat {
        return CommonUtilities.util.isIphone16ProMaxPortrait ? 145 : 125
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Section title
            Text(title)
                .font(
                    Font.custom("Qanelas Soft DEMO", size: 20)
                        .weight(.medium)
                )
                .foregroundColor(Constants.LabelsPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 5)
            
            // Text editor for user input
            ZStack(alignment: .topLeading) {
                if isEditable {
                    TextEditor(text: $text)
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal, 2)
                        .frame(maxWidth: .infinity, minHeight: textFieldHeight, maxHeight: textFieldHeight, alignment: .topLeading)
                        .scrollContentBackground(.hidden)
                        .background(
                            Color(red: 0.87, green: 0.95, blue: 0.99)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                        }
                        .focused($focusedField)
                    
                } else {
                    ScrollView {
                        Text(text)
                            .padding(8)
                    }
                    .frame(maxWidth: .infinity, minHeight: textFieldHeight, maxHeight: textFieldHeight, alignment: .topLeading)
                    .background(
                        Color(red: 0.87, green: 0.95, blue: 0.99)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .inset(by: 0.5)
                            .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                    }
                }
                
                if text.isEmpty {
                    Text(isEditable ? "Type your response here..." : "This entry is empty")
                        .foregroundStyle(Color.gray)
                        .padding(8)
                        .allowsHitTesting(false)
                }
            }
            
        }
    }
}
