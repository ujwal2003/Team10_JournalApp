//
//  HomeLandscapeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/4/24.
//

import SwiftUI

struct HomeLandscapeView: View {
    @State var usePreviewMocks: Bool = false
    
    @ObservedObject var appController: AppViewController
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            
            AppLayoutContainer(height: 2.0) {
                VStack(spacing: 0.0) {
                    Text("CatchUp")
                        .font(.system(size: 30.0))
                        .fontWeight(.heavy)
                        .padding([.top, .leading, .trailing])
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Group {
                        if let userProfile = appController.loadedUserProfile {
                            Text("Welcome, \(userProfile.displayName)")
                        } else {
                            Text("Loading...")
                        }
                    }
                    .font(.system(size: 20.0))
                    .fontWeight(.light)
                    .padding([.leading, .trailing, .bottom])
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            } containerContent: {
                HStack {
                    
                    LandscapeJournalMapView(
                        map: .Map1,
                        buildings: [
                            .init(style: .BlueConstruction, onClick: {}),
                            .init(style: .BlueConstruction, onClick: {}),
                            .init(style: .BlueConstruction, onClick: {}),
                            .init(style: .BlueConstruction, onClick: {}),
                            .init(style: .BlueConstruction, onClick: {}),
                            .init(style: .BlueConstruction, onClick: {}),
                            .init(style: .BlueConstruction, onClick: {})
                        ]
                    )
                    .padding()
                    // TODO: add sheet here
                    
                    VStack {
                        CityStatsView(
                            percentage: 1.0,
                            weather: .NoData
                        )
                        
                        ActionButtonView(
                            isDisabled: false,
                            onClick: {}
                        )
                        //TODO: add sheet here
                        
                        BottomNavigationView(
                            isDisabled: false,
                            onLeftArrowClick: {},
                            onRightArrowClick: {},
                            currWeek: "12/01/24 - 12/07/24",
                            numFriends: 5
                        )
                    }
                    .padding(.bottom)
                    
                }
                
            }
            
        }
    }
}

#Preview {
    AppTabMockContainerView(previewTab: .Home) {
        HomeLandscapeView(
            usePreviewMocks: true,
            appController: AppViewController()
        )
    }
}
