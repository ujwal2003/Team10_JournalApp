//
//  UserJournalCityBlockView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/17/24.
//

import SwiftUI

struct UserJournalCityBlockView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Map_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .frame(width: geometry.size.width, alignment: .center)
                
                Button(action: {}) {
                    VStack(spacing: -20) {
                        Image("SundayBillboard")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                        
                        Image("light_blue_building")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * 0.18)
                    }
                    
                }
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.8)
                
            }
        }
    }
}
