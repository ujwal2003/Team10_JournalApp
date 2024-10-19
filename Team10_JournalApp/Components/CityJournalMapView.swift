//
//  CityJournalMapView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/19/24.
//

import SwiftUI

//! Magic Number
let isIphone16ProMaxPortrait: Bool = UIScreen.main.bounds.height == 956.0

enum Map: String {
    case Map1 = "Map_1"
    case Map2 = "Map_2"
    case Map3 = "Map_3"
    case Map4 = "Map_4"
}

enum Building: String {
    case BlueTower = "blue_building"
    case BrownTower = "brown_building"
}

struct BuildingView: View {
    var geometry: GeometryProxy
    var xCoord: CGFloat
    var yCoord: CGFloat
    var onClick: () -> Void
    
    init(geometry: GeometryProxy, xCoord: CGFloat, yCoord: CGFloat, onClick: @escaping () -> Void) {
        self.geometry = geometry
        self.onClick = onClick
        
        self.xCoord = min(max(xCoord, 0), 1)
        self.yCoord = min(max(yCoord, 0), 1)
    }
    
    var body: some View {
        Button(action: { onClick() }, label: {
            Image("blue_building")
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 1,
                       height: geometry.size.height * 0.16)
        })
        .position(x: geometry.size.width * xCoord, y: geometry.size.height * yCoord)
    }
}

struct CityJournalMapView: View {
    var map: Map = .Map1
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(map.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                    .scaleEffect(x: isIphone16ProMaxPortrait ? 1 : 1.13)
                
                BuildingView(geometry: geometry,
                             xCoord: 0.88, yCoord: 0.15,
                             onClick: { print("hiiiii!") })
                
                Button(action: { print("cyan building clicked") }, label: {
                    Image(systemName: "building.fill")
                        .resizable()
                        .frame(width: geometry.size.width * 0.1,
                               height: geometry.size.height * 0.15)
                        .foregroundStyle(Color.cyan)
                })
                .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.75)
                
            }
        }
    }
}

//#Preview {
//    CityJournalMapView()
//}
