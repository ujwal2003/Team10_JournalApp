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
    
    func getCityHealthColors() -> (borderColor: Color, barColor: Color) {
        if cityHealthPercentage >= 0.75 {
            print("returned Green")
            return (borderColor: Color(red: 0, green: 0.66, blue: 0.39).opacity(0.4),
                    barColor: Color(red: 0.79, green: 1, blue: 0.87))
            
        } else if cityHealthPercentage >= 0.50 {
            print("returned Yellow")
            return (borderColor: Color(red: 0.84, green: 0.86, blue: 0.01).opacity(0.53),
                    barColor: Color(red: 0.98, green: 1, blue: 0.79))
            
        } else if cityHealthPercentage >= 0.25 {
            print("returned Orange")
            return (borderColor: Color(red: 0.66, green: 0.46, blue: 0).opacity(0.4),
                    barColor: Color(red: 1, green: 0.94, blue: 0.79))
        }
        
        print("returned Red")
        return (borderColor: Color(red: 0.66, green: 0.16, blue: 0).opacity(0.4),
                barColor: Color(red: 1, green: 0.84, blue: 0.79))
    }
    
}
