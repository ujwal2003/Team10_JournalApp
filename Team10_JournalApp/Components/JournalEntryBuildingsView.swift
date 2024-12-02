//
//  JournalEntryBuildingsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/1/24.
//

import SwiftUI

struct JournalEntryBuildingsView: View {
    @State var usePreviewMocks: Bool
    
    @Environment(\.dismiss) var dismiss
    @State var selectedMenuView: CityBuildingViewSelection
    
    @State var building: Building
    @State var date: Date
    @State var journalID: String
    
    @State var fetchedJournalEntry: JournalEntry?
    
    @StateObject var viewModel = CityJournalBuildingViewModel()
    
    init(
        usePreviewMocks: Bool = false,
        selectedMenuView: CityBuildingViewSelection = .Sentiment,
        building: Building,
        date: Date,
        journalID: String
    ) {
        self.usePreviewMocks = usePreviewMocks
        self.selectedMenuView = selectedMenuView
        self.building = building
        self.date = date
        self.journalID = journalID
        self.fetchedJournalEntry = nil
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        
                        let headlineTitle = viewModel.getViewTitle(date: self.date, building: self.building)
                        VStack(spacing: 0) {
                            Text(headlineTitle)
                                .font(.system(size: 30))
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                            
                            Picker("Selection", selection: $selectedMenuView) {
                                Text("Sentiment").tag(CityBuildingViewSelection.Sentiment)
                                Text("Journal").tag(CityBuildingViewSelection.Journal)
                            }
                            .pickerStyle(.segmented)
                            .padding([.leading, .bottom, .trailing])
                        }
                        
                        if self.building.category != .Building && self.building != .Scaffolding {
                            viewModel.getConstructionOrRuinIndicatorsView(building: building)
                            
                        } else if self.building == .Scaffolding {
                            viewModel.getScaffoldingIndicatorsView()
                            
                        } else {
                            if let journalEntry = self.fetchedJournalEntry {
                                let isJournalMode = self.selectedMenuView == .Journal
                                
                                GrowthReportView(
                                    geometry: geometry,
                                    title: "Gratitude Building",
                                    text: isJournalMode ? journalEntry.gratitudeEntry : journalEntry.gratitudeDecodedSentiment.report,
                                    sentiment: journalEntry.gratitudeDecodedSentiment
                                )
                                
                                GrowthReportView(
                                    geometry: geometry,
                                    title: "Learning Building",
                                    text: isJournalMode ? journalEntry.learningEntry : journalEntry.learningDecodedSentiment.report,
                                    sentiment: journalEntry.learningDecodedSentiment
                                )
                                
                                GrowthReportView(
                                    geometry: geometry,
                                    title: "Thought Building",
                                    text: isJournalMode ? journalEntry.thoughtEntry : journalEntry.thoughtDecodedSentiment.report,
                                    sentiment: journalEntry.thoughtDecodedSentiment
                                )
                                
                            } else {
                                ProgressView {
                                    Text("Loading...")
                                }
                                .controlSize(.extraLarge)
                                .padding(.vertical, 70.0)
                            }
                            
                        }
                    }
                    .task {
                        if usePreviewMocks {
                            self.fetchedJournalEntry = MockDataManager.mock.getMockJournalEntry()
                            
                        } else {
                            if self.building.category == .Building {
                                do {
                                    let fetchedEntry = try await JournalManager.shared.getJournalEntryFromId(journalId: self.journalID)
                                    self.fetchedJournalEntry = fetchedEntry
                                    
                                } catch {
                                    self.selectedMenuView = .Journal
                                    self.fetchedJournalEntry = viewModel.getErroredEntry()
                                }
                            }
                        }
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                          .font(.custom("SF Pro", size: 16).weight(.semibold))
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                    }

                }
            }
            
        }
        
    }
}

#Preview {
    JournalEntryBuildingsView(
        usePreviewMocks: true,
        building: .RedTower,
        date: Date(),
        journalID: ""
    )
}
