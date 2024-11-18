//
//  HomeViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/18/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var cityHealthPercentage: CGFloat = 0.0
    @Published var currSentimentWeather: JournalWeather = .NoData
    
    @Published var currMap: Map = .LoadingMap
    @Published var currCityBlockBuildings: [BuildingConfig] = []
    
}
