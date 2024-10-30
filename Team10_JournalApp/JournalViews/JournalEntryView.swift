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
        case gratitude; case learning; case thoughts
    }
    
    var body: some View {
        
        NavigationStack {
            DefaultRectContainer(
                title: .init(text: "Journal Entry", fontSize: 40.0),
                subtitle: .init(text: currentDate, fontSize: 20.0),
                minifiedFrame: true,
                headTopAlign: .topCentralAlign
            ) {
                ScrollView {
                    VStack {
                        Spacer()
                            .padding(5)
                        
                        Grid(horizontalSpacing: 10, verticalSpacing: 21) {
                            GridRow {
                                Text("What are you grateful for?")
                                    .font(
                                        Font.custom("Qanelas Soft DEMO", size: 20)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(Constants.LabelsPrimary)
                            }
                            
                            GridRow {
                                TextEditor(text: $gratefulEntry)
                                    .frame(width: 361, height: 111)
                                    .scrollContentBackground(.hidden)
                                    .background(Color(red: 0.87, green: 0.95, blue: 0.99))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                                    )
                                    .focused($focusedField, equals: .gratitude)
                            }
                            
                            GridRow {
                                Text("What did you learn today?")
                                    .font(
                                        Font.custom("Qanelas Soft DEMO", size: 20)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(Constants.LabelsPrimary)
                            }
                            
                            GridRow {
                                TextEditor(text: $learnEntry)
                                    .frame(width: 361, height: 111)
                                    .scrollContentBackground(.hidden)
                                    .background(Color(red: 0.87, green: 0.95, blue: 0.99))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                                    )
                                    .focused($focusedField, equals: .learning)
                            }
                            
                            GridRow {
                                Text("Thought dump for the day")
                                    .font(
                                        Font.custom("Qanelas Soft DEMO", size: 20)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(Constants.LabelsPrimary)
                            }
                            
                            GridRow {
                                
                                TextEditor(text: $thoughtEntry)
                                    .frame(width: 361, height: 111)
                                    .scrollContentBackground(.hidden)
                                    .background(Color(red: 0.87, green: 0.95, blue: 0.99))
                                    .cornerRadius(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.4), lineWidth: 1)
                                    )
                                    .focused($focusedField, equals: .thoughts)
                            }
                        }
                        .padding([.bottom], 40)
                        
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
                                    
                                    Text("Complete Journal Entry")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                }
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
                    }
                    .padding([.bottom], 80)
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            
        }
        
        
    }
}

#Preview {
    JournalEntryView()
}
