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
    var map: Map = .Map3
    var buildings: [BuildingConfig] = [
        .init(style: .LightBlueTower, onClick: {}),
        .init(style: .RedRuin, onClick: {}),
        .init(style: .PurpleConstruction, onClick: {}),
        .init(style: .Scaffolding, onClick: {}),
        .init(style: .PurpleConstruction, onClick: {}),
        .init(style: .BrownTower, onClick: {}),
        .init(style: .LightGreenTower, onClick: {})
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(map.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .frame(width: geometry.size.width, alignment: .center)
                
                let buildingViews: [CityBuildingView] = getMapBuildings(
                    geometry: geometry,
                    map: map,
                    buildingsList: buildings
                )
                
                ForEach(buildingViews, id: \.id) { buildingView in
                    buildingView
                }
                
            }
        }
        
    }
    
    private func getBuildingCoords(map: Map) -> [(x: CGFloat, y: CGFloat)] {
        switch map {
        case .LoadingMap: return []
        case .NotFoundMap: return []
            
        case .Map1:
            return [
                (0.10, 0.15), (0.42, 0.20), (0.84, 0.14), (0.18, 0.65),
                (0.32, 0.88), (0.58, 0.62), (0.82, 0.82)
            ]
            
        case .Map2:
            return [
                (0.16, 0.10), (0.44, 0.20), (0.85, 0.12), (0.15, 0.52),
                (0.38, 0.85), (0.80, 0.85), (0.72, 0.56)
            ]
            
        case .Map3:
            return [
                (0.22, 0.18), (0.10, 0.40), (0.15, 0.70), (0.35, 0.85),
                (0.62, 0.42), (0.90, 0.08), (0.88, 0.82)
            ]
            
        case .Map4:
            return [
                (0.10, 0.10), (0.35, 0.28), (0.85, 0.10), (0.70, 0.60),
                (0.08, 0.52), (0.22, 0.90), (0.90, 0.82)
            ]
        }
    }
    
    private func getBuildingSign(dayIndex: Int, building: Building, map: Map) -> BuildingNameSign {
        let prefersBillboard: () -> Bool = {
            return building.category.preferredSign == .Billboard
        }
        
        let billboardOverride: () -> Bool = {
            switch map {
                case .Map2:
                    if dayIndex == 0 || dayIndex == 2 {
                        return true
                    } else {
                        return false
                    }
                
                default: return false
            }
        }
        
        let useBillboard: () -> Bool = {
            if prefersBillboard() {
                return billboardOverride() ? false : true
            }
            return false
        }
        
        
        switch dayIndex {
            case 0: return useBillboard() ? .SundayBillboard : .SundaySign
            case 1: return useBillboard() ? .MondayBillboard : .MondaySign
            case 2: return useBillboard() ? .TuesdayBillboard : .TuesdaySign
            case 3: return useBillboard() ? .WednesdayBillboard : .WednesdaySign
            case 4: return useBillboard() ? .ThursdayBillboard : .ThursdaySign
            case 5: return useBillboard() ? .FridayBillboard : .FridaySign
            case 6: return useBillboard() ? .SaturdayBillboard : .SaturdaySign
            
            default: return .SundaySign
        }
    }
    
    private func getMapBuildings(geometry: GeometryProxy, map: Map, buildingsList: [BuildingConfig]) -> [CityBuildingView] {
        let coords = getBuildingCoords(map: map)
        var buildingViews: [CityBuildingView] = []
        
        if coords.isEmpty {
            return buildingViews
        }
        
        for i in 0..<7 {
            buildingViews.append(
                .init(
                    building: buildingsList[i].style,
                    buildingHeight: geometry.size.height * 0.18,
                    buildingNameSign: getBuildingSign(dayIndex: i, building: buildingsList[i].style, map: map),
                    buildingSignHeight: 60,
                    coords: (x: geometry.size.width * coords[i].x, y: geometry.size.height * coords[i].y),
                    onClick: buildingsList[i].onClick
                )
            )
        }
        
        return buildingViews
    }
}
