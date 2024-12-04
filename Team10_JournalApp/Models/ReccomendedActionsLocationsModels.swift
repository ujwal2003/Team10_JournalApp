//
//  ReccomendedActionsLocationsModels.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/4/24.
//

import Foundation

enum CreativeSpaces: String {
    case ArtStudios = "Art Studios"
    case Makerspaces = "Makerspaces"
    case ScenicViews = "Scenic Views"
    case Libraries = "Libraries"
    case Music = "Music"
    
    var mapActionSearch: RecommendedAction {
        switch self {
            case .ArtStudios:
                return .init(searchQuery: "Art Studios", title: self.rawValue, description: "Try to strengthen your creative muscles by going to local art studios.")
            case .Makerspaces:
                return .init(searchQuery: "Makerspaces", title: self.rawValue, description: "Work on 3D printing, woodworking, or electronics projects at a local makerspace.")
            case .ScenicViews:
                return .init(searchQuery: "Scenic Views", title: self.rawValue, description: "Visit a monument, downtown area, or a scenic spot to take some photos.")
            case .Libraries:
                return .init(searchQuery: "Library", title: self.rawValue, description: "Go to a cozy library to find a quiet place to read or write.")
            case .Music:
                return .init(searchQuery: "Music", title: self.rawValue, description: "Visit a music hall or music stuio to practice, perform or listen to music in a community-friendly environment.")
        }
    }
}

enum EnjoyableExperiences: String {
    case Parks = "Parks & Gardens"
    case ThemeParks = "Theme Parks"
    case Museums = "Museums"
    case Cafes = "Cafes"
    case Theatres = "Theatres"
    
    var mapActionSearch: RecommendedAction {
        switch self {
            case .Parks:
                return .init(searchQuery: "Parks and Gardens", title: self.rawValue, description: "Enjoy walking, sitting, or poeple-watching in a peaceful setting.")
            case .ThemeParks:
                return .init(searchQuery: "Theme Parks", title: "Amusement or Theme Parks", description: "Engage in thrilling rides or playful experiences.")
            case .Museums:
                return .init(searchQuery: "Museums", title: self.rawValue, description: "Get inspired by art, history, or science exhibits.")
            case .Cafes:
                return .init(searchQuery: "Cafes", title: self.rawValue, description: "Relax with a good book, sketchpad, or simply enjoy the ambiance.")
            case .Theatres:
                return .init(searchQuery: "Theatres", title: self.rawValue, description: "Attend a theatre show and enjoy the performance.")
        }
    }
}

enum InteractiveVenues: String {
    case EscapeRooms = "Escape Rooms"
    case CookingClasses = "Cooking Classes"
    case DanceStudios = "Dance Studios"
    case Karaoke = "Karaoke"
    case CommunityGardens = "Community Gardens"
    case Swimming = "Swimming"
    
    var mapActionSearch: RecommendedAction {
        switch self {
            case .EscapeRooms:
                return .init(searchQuery: "Escape Rooms", title: self.rawValue, description: "Solve puzzles and mysteries with friends.")
            case .CookingClasses:
                return .init(searchQuery: "Cooking Classes", title: self.rawValue, description: "Learn a new recipe or skill while enjoyng the process.")
            case .DanceStudios:
                return .init(searchQuery: "Dance Studios", title: self.rawValue, description: "Try out dancing while enjoying the learning experience.")
            case .Karaoke:
                return .init(searchQuery: "Karaoke", title: self.rawValue, description: "Have fun singing your favorite songs with friends.")
            case .CommunityGardens:
                return .init(searchQuery: "Community Gardens", title: self.rawValue, description: "Dig into nature while planting or learning about sustainability.")
            case .Swimming:
                return .init(searchQuery: "Swimming", title: self.rawValue, description: "Enjoy taking some time in the water.")
        }
    }
}

enum SereneEnvironments: String {
    case Trails = "Nature Trails"
    case Hiking = "Hiking Trails"
    case Beaches = "Beaches"
    case Aquariums = "Aquariums"
    case Planetariums = "Planetariums"
    
    var mapActionSearch: RecommendedAction {
        switch self {
            case .Trails:
                return .init(searchQuery: "Nature Trails", title: self.rawValue, description: "Connect with nature taking a walk or sitting in a peaceful environment.")
            case .Hiking:
                return .init(searchQuery: "Hiking Trails", title: self.rawValue, description: "Explore the environment by hiking.")
            case .Beaches:
                return .init(searchQuery: "Beaches", title: "Beach", description: "Relax and enjoy sitting by the water.")
            case .Aquariums:
                return .init(searchQuery: "Aquariums", title: self.rawValue, description: "Explore the underwater and watch life swimming around you.")
            case .Planetariums:
                return .init(searchQuery: "Planetariums", title: self.rawValue, description: "Immerse youself in calming, awe-inspiring environments.")
        }
    }
}
