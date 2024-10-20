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
    case LoadingMap = "LoadingMap"
    case NotFoundMap = "NotFoundMap"
}

enum Building: String {
    case BlueTower = "blue_building"
    case BrownTower = "brown_building"
    case GreenTower = "green_building"
    case LightBlueTower = "light_blue_building"
    case LightBrownTower = "light_brown_building"
    case LightGreenTower = "light_green_building"
    case RedTower = "red_building"
}

struct BuildingConfig {
    var style: Building
    var onClick: () -> Void
}

struct BuildingView: View {
    var id = UUID()
    var geometry: GeometryProxy
    var building: Building
    var coords: (x: CGFloat, y: CGFloat)
    var onClick: () -> Void
    
    init(geometry: GeometryProxy,
         building: Building,
         coords: (x: CGFloat, y: CGFloat),
         onClick: @escaping () -> Void) {
        
        self.geometry = geometry
        self.building = building
        self.onClick = onClick
        
        self.coords = (
            x: min(max(coords.x, 0), 1),
            y: min(max(coords.y, 0), 1)
        )
    }
    
    var body: some View {
        Button(action: { onClick() }, label: {
            Image(building.rawValue)
                .resizable()
                .scaledToFit()
                .frame(height: geometry.size.height * 0.16)
        })
        .position(x: geometry.size.width * coords.x, y: geometry.size.height * coords.y)
    }
}

struct CityJournalMapView: View {
    var map: Map
    var buildings: [BuildingConfig]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(map.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                    .scaleEffect(x: isIphone16ProMaxPortrait ? 1 : 1.13)
                
                let buildingViews: [BuildingView] = getMapBuildings(geometry: geometry,
                                                                    map: map,
                                                                    buildingsConfig: buildings)
                
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
                    (0.12, 0.08), (0.40, 0.18), (0.88, 0.12), (0.12, 0.65),
                    (0.35, 0.85), (0.58, 0.70), (0.86, 0.82)
                ]
            
            case .Map2:
                return [
                    (0.12, 0.10), (0.38, 0.20), (0.9, 0.12), (0.08, 0.54),
                    (0.32, 0.90), (0.90, 0.90), (0.75, 0.62)
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
    
    private func getMapBuildings(geometry: GeometryProxy, map: Map, buildingsConfig: [BuildingConfig]) -> [BuildingView] {
        
        let coords = getBuildingCoords(map: map)
        var buildingsList: [BuildingView] = []
        
        if coords.isEmpty {
            return buildingsList
        }
        
        for i in 0..<7 {
            buildingsList.append(
                .init(geometry: geometry,
                      building: buildingsConfig[i].style,
                      coords: coords[i],
                      onClick: buildingsConfig[i].onClick)
            )
        }
        
        return buildingsList
    }
}

//#Preview {
//    CityJournalMapView()
//}
