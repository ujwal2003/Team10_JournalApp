//
//  CityMapModels.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/17/24.
//

import Foundation

enum Map: String {
    case Map1 = "Map_1"
    case Map2 = "Map_2"
    case Map3 = "Map_3"
    case Map4 = "Map_4"
    case LoadingMap = "LoadingMap"
    case NotFoundMap = "NotFoundMap"
}

enum BuildingCategory {
    case Building
    case Construction
    case Ruin
    
    var preferredSign: BuildingNameSignCategory {
        switch self {
            case .Building:
                return .Billboard
            default:
                return .Sign
        }
    }
}

enum Building: String {
    case Scaffolding = "Scaffolding"
    
    case BlueTower = "blue_building"
    case BrownTower = "brown_building"
    case GreenTower = "green_building"
    case LightBlueTower = "light_blue_building"
    case LightBrownTower = "light_brown_building"
    case LightGreenTower = "light_green_building"
    case RedTower = "red_building"
    
    case BlueConstruction = "BlueConstruction"
    case BrownConstruction = "BrownConstruction"
    case DarkRedConstruction = "DarkRedConstruction"
    case GreenConstruction = "GreenConstruction"
    case PurpleConstruction = "PurpleConstruction"
    case RedConstruction = "RedConstruction"
    case YellowConstruction = "YellowConstruction"
    
    case BlueRuin = "BlueRuin"
    case BrownRuin = "BrownRuin"
    case DarkRedRuin = "DarkRedRuin"
    case GreenRuin = "GreenRuin"
    case PurpleRuin = "PurpleRuin"
    case RedRuin = "RedRuin"
    case YellowRuin = "YellowRuin"
    
    var category: BuildingCategory {
        switch self {
            case .BlueTower, .BrownTower, .GreenTower, .LightBlueTower,
                    .LightBrownTower, .LightGreenTower, .RedTower:
                return .Building
            
            case .BlueConstruction, .BrownConstruction, .DarkRedConstruction, .GreenConstruction,
                .PurpleConstruction, .RedConstruction, .YellowConstruction, .Scaffolding:
                return .Construction
            
            case .BlueRuin, .BrownRuin, .DarkRedRuin, .GreenRuin,
                    .PurpleRuin, .RedRuin, .YellowRuin:
                return .Ruin
        }
    }
}

enum BuildingNameSignCategory {
    case Sign
    case Billboard
}

enum BuildingNameSign: String {
    case SundayBillboard = "SundayBillboard"
    case MondayBillboard = "MondayBillboard"
    case TuesdayBillboard = "TuesdayBillboard"
    case WednesdayBillboard = "WednesdayBillboard"
    case ThursdayBillboard = "ThursdayBillboard"
    case FridayBillboard = "FridayBillboard"
    case SaturdayBillboard = "SaturdayBillboard"
    
    case SundaySign = "SundaySign"
    case MondaySign = "MondaySign"
    case TuesdaySign = "TuesdaySign"
    case WednesdaySign = "WednesdaySign"
    case ThursdaySign = "ThursdaySign"
    case FridaySign = "FridaySign"
    case SaturdaySign = "SaturdaySign"
    
    var category: BuildingNameSignCategory {
        switch self {
            case .SundayBillboard, .MondayBillboard, .TuesdayBillboard, .WednesdayBillboard,
                    .ThursdayBillboard, .FridayBillboard, .SaturdayBillboard:
                return .Billboard
            
            case .SundaySign, .MondaySign, .TuesdaySign, .WednesdaySign,
                    .ThursdaySign, .FridaySign, .SaturdaySign:
            return .Sign
        }
    }
}

struct BuildingConfig {
    var style: Building
    var onClick: () -> Void
}
