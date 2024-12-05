//
//  ReccomendedActionsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/20/24.
//

import SwiftUI
import MapKit

struct ActionsMapView: View {
    var actionTitle: String
    var data: MapData
    var description: String
    var openMapFunction: () -> Void
    
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack(spacing: 5.0) {
            HStack {
                Text(actionTitle)
                    .font(.system(size: 24.0))
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { openMapFunction() }) {
                    Text("Open in maps")
                        .font(.system(size: 16.0))
                        .padding(.horizontal)
                }
            }
            
            VStack {
                ScrollView {
                    Text(description)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 40)
                .padding([.top, .leading, .trailing])
                .padding(.bottom, 5.0)
                
                MapView(region: .constant(data.region), annotations: .constant(data.annotations))
                    .frame(height: 200)
                    .onAppear {
                        isLoading = false
                    }
            }
            .background(Color(red: 0.87, green: 0.95, blue: 0.99))
            .clipShape(RoundedCorner(radius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.8), lineWidth: 1)
            )
            .frame(height: 300)
        }
    }
}

struct ReccomendedActionsView: View {
    @State var overallSentiment: Sentiment
    @State var actions: [RecommendedAction]
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ActionsViewModel()
    @State var isLoading: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    
                    HStack {
                        Spacer()
                        Button("Done") {
                            dismiss()
                        }
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding([.top, .leading, .trailing])
                    }
                    
                    Text("Recommended Actions\nfor Today")
                        .font(.system(size: 28))
                        .fontWeight(.heavy)
                        .lineSpacing(10)
                        .padding()
                    
                    if actions.isEmpty {
                        Image("tabler_map-question")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 290)
                        
                        Text("Write your journal\nfor today to see\nrecommended actions")
                            .font(.system(size: 32))
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                        
                    } else {
                        Group {
                            Text("Your overall sentiment is ")
                            + overallSentiment.textView
                            + Text(", consider taking the following actions:")
                        }
                        .font(.system(size: 18.0))
                        .fontWeight(.medium)
                        .lineSpacing(6)
                        .padding()
                        .padding(.horizontal, 5.0)
                            
                        VStack {
                            if isLoading {
                                ProgressView {
                                    Text("Loading...")
                                }
                            }
                            
                            ForEach(Array(viewModel.mapsData.enumerated()), id: \.offset) { index, data in
                                ActionsMapView(
                                    actionTitle: actions[index].title,
                                    data: data,
                                    description: actions[index].description,
                                    openMapFunction: {
                                        viewModel.openAllInMaps(annotations: data.annotations)
                                    },
                                    isLoading: $isLoading
                                )
                            }
                        }
                        .padding(25)
                    
                    }
                    
                }
            }
        }
        .onAppear {
            for action in actions {
                viewModel.searchNearbyLocations(query: action.searchQuery, title: action.title)
            }
        }
    }
    
}

#Preview {
    @Previewable @State var viewEmptyStatePreview = false
    
    if viewEmptyStatePreview {
        ReccomendedActionsView(overallSentiment: .Negative, actions: [])
        
    } else {
        ReccomendedActionsView(
            overallSentiment: .Negative,
            actions: [
                .init(searchQuery: "parks",
                      title: "Park",
                      description: "Going to the park is a great way to improve your physical and mental health."),
                
                    .init(searchQuery: "coffee shops",
                          title: "Chill & Chat",
                          description: "Reach out to a friend or loved one for a chat at a coffee shop")
            ]
        )
    }
    
}
