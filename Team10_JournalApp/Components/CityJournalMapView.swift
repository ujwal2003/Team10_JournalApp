//
//  CityJournalMapView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/19/24.
//

import SwiftUI

struct CityJournalMapView: View {
    
    //! Magic Number
    let isIphone16ProMaxPortrait: Bool = UIScreen.main.bounds.height == 956.0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("Map_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width)
                    .scaleEffect(x: isIphone16ProMaxPortrait ? 1 : 1.13)
                
                Button(action: { print("green building clicked!") }, label: {
                    Image(systemName: "building.fill")
                        .resizable()
                        .frame(width: geometry.size.width * 0.1,
                               height: geometry.size.height * 0.15)
                        .foregroundStyle(Color.green)
                })
                .position(x: geometry.size.width * 0.88, y: geometry.size.height * 0.15)
                
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
