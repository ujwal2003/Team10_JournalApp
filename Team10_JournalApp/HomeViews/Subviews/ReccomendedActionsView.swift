//
//  ReccomendedActionsView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/20/24.
//

import SwiftUI
import MapKit

struct ActionsMapView: View {
//    var data: MapData
    var description: String
    
    var body: some View {
        VStack(spacing: 5.0) {
            Text("Action 1")
                .font(.system(size: 24.0))
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                ScrollView {
                    Text(description)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 40)
                .padding()
                
                Rectangle()
                    .foregroundStyle(Color.gray)
                    .frame(height: 200)
            }
            .background(Color(red: 0.87, green: 0.95, blue: 0.99))
            .clipShape(RoundedCorner(radius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.8), lineWidth: 1)
            )
            .frame(height: 300)
            
//            MapView(region: .constant(data.region), annotations: .constant(data.annotations))
//                .frame(height: 200)
        }
    }
}

struct ReccomendedActionsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ActionsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    
                    HStack {
                        Spacer()
                        Button("Done") {
                            dismiss()
                        }
                        .fontWeight(.semibold)
                        .padding([.top, .leading, .trailing])
                    }
                    
                    Text("Recommended Actions\nfor Today")
                        .font(.system(size: 28))
                        .fontWeight(.heavy)
                        .lineSpacing(10)
                        .padding()
                    
                    Group {
                        Text("Your overall sentiment is ")
                        + Text("Negative").foregroundStyle(Color.hex("#DE5353"))
                        + Text(", consider taking the following actions:")
                    }
                    .font(.system(size: 18.0))
                    .fontWeight(.medium)
                    .lineSpacing(6)
                    .padding()
                    
                    VStack {
                        ActionsMapView(description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
//                        ForEach(viewModel.mapsData) { data in
//                            
//                        }
                    }
                    .padding()
                    
                }
            }
        }
        .onAppear {
//            viewModel.searchNearbyLocations(query: "ice cream", title: "Ice Cream")
        }
    }
    
}

#Preview {
    ReccomendedActionsView()
}
