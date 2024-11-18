//
//  UserJournalCityBlockView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/17/24.
//

import SwiftUI

struct CityBuildingView: View {
    var id = UUID()
    
    var building: Building
    var buildingHeight: CGFloat
    
    var buildingNameSign: BuildingNameSign
    var buildingSignHeight: CGFloat
    
    var coords: (x: CGFloat, y: CGFloat)
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            if buildingNameSign.category == .Billboard {
                VStack(spacing: -20) {
                    Image(buildingNameSign.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: buildingSignHeight)
                    
                    Image(building.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: buildingHeight)
                }
                
            } else if buildingNameSign.category == .Sign {
                HStack(spacing: -10) {
                    Image(building.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: buildingHeight)
                    
                    Image(buildingNameSign.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: buildingSignHeight)
                }
            }
        }
        .position(x: coords.x, y: coords.y)
        
    }
}

struct UserJournalCityBlockView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Map_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .frame(width: geometry.size.width, alignment: .center)
                
                CityBuildingView(
                    building: .RedRuin,
                    buildingHeight: geometry.size.height * 0.18,
                    buildingNameSign: .SundaySign,
                    buildingSignHeight: 60,
                    coords: (x: geometry.size.width * 0.5, y: geometry.size.height * 0.8),
                    onClick: {}
                )
                
            }
        }
        
    }
}
