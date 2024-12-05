//
//  LandscapeJournalMapView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/4/24.
//

import SwiftUI

struct LandscapeJournalMapView: View {
    var map: Map
    var buildings: [BuildingConfig]
    
    var body: some View {
        ZStack {
            Image(map.rawValue)
                .resizable()
                .scaledToFit()
                .padding(5)
            
            NavigationLink {
                ScrollView {
                    VStack {
                        let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                        
                        ForEach(buildings.indices, id: \.self) { index in
                            let building = buildings[index]
                            
                            Button {
                                building.onClick()
                                
                            } label: {
                                HStack {
                                    Image(building.style.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80)
                                    
                                    Spacer()
                                    
                                    Text(days[index])
                                        .font(.system(size: 20))
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                
                            }
                            .buttonStyle(
                                BubbleButtonStyle(
                                    backgroundColor: Color(.systemGray2),
                                    textColor: Color.white
                                )
                            )
                            .padding(5)
                            
                        }
                    }
                }
                
            } label: {
                if map != .LoadingMap && map != .NotFoundMap {
                    VStack {
                        Image(systemName: "7.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundStyle(Color.yellow)
                            .shadow(radius: 5)
                        
                        HStack(spacing: 0) {
                            Image(Building.PurpleConstruction.rawValue)
                            Image(Building.LightBrownTower.rawValue)
                            Image(Building.GreenRuin.rawValue)
                        }
                    }
                }
            }
            
        }
        
    }
}
